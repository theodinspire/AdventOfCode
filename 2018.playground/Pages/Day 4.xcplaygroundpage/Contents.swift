import Foundation
import AdventOfCode

import Regex

typealias Guard = Int
typealias Minute = Int

guard let filepath = Bundle.main.url(forResource: "04", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
""".components(separatedBy: .newlines)

let calendar = Calendar.current

struct ShiftLog {
    enum Action {
        case BeginShift(Guard)
        case FallsAsleep
        case WakesUp
    }

    let timestamp: Date
    let action: Action

    static let dateFormatter = DateFormatter(from: "yyyy-MM-dd HH:mm")
    static let baseRegex = Regex("^\\[(\\d{4}-\\d\\d-\\d\\d \\d\\d:\\d\\d)\\] (.+)$")
    static let shiftRegex = Regex("^Guard #(\\d+) begins shift$")
    static let sleepString = "falls asleep"
    static let awakeString = "wakes up"

    init?(from entry: String) {
        guard let halves = ShiftLog.baseRegex.firstMatch(in: entry)?.captures.compacted(), halves.count == 2, let date = ShiftLog.dateFormatter.date(from: halves[0]) else { return nil }

        timestamp = date

        let action = halves[1]

        if let guardId = ShiftLog.shiftRegex.firstMatch(in: action)?.captures.first ?? nil, let id = Int(guardId) {
            self.action = .BeginShift(id)
        } else if action == ShiftLog.sleepString {
            self.action = .FallsAsleep
        } else if action == ShiftLog.awakeString {
            self.action = .WakesUp
        } else { return nil }
    }
}

let input =
//    sample.compactMap(ShiftLog.init)
    stream.compactMap(ShiftLog.init).sorted(by: { $0.timestamp < $1.timestamp })

// Confirm that all sleeping logs are withing the witchinng hour
guard input.count(where: { switch $0.action { case .BeginShift(_): return false; default: return calendar.component(.hour, from: $0.timestamp) != 0 } }) == 0 else { fatalError("Sleep/Waking action occurs outside of 00h00") }

// Part 1
var currentGuard: Int?
var startSleep: Int?

var guardsSleepLog = [Guard: Counter<Minute>]()

loop: for log in input {
    switch log.action {
    case .BeginShift(let elf):
        currentGuard = elf
    case .FallsAsleep:
        startSleep = calendar.component(.minute, from: log.timestamp)
    case .WakesUp:
        guard let elf = currentGuard else {
            print("No guard posted")
            break loop
        }

        guard let sleep = startSleep else {
            print("Guard change of sleeping elves")
            break loop
        }

        let wake = calendar.component(.minute, from: log.timestamp)
        (sleep..<wake).forEach { guardsSleepLog[elf, default: [:]].record(item: $0) }

        startSleep = nil
    }
}

let sleepy = guardsSleepLog.max { $0.value.values.reduce(0, +) < $1.value.values.reduce(0, +) }?.key ?? 0
let sleepysMinute = guardsSleepLog[sleepy]?.max { $0.value < $1.value }?.key ?? 0

print(sleepy * sleepysMinute)

// Part 2
let dependable = guardsSleepLog.max { $0.value.values.max() ?? Int.min < $1.value.values.max() ?? Int.min }?.key ?? 0
let dependablesMinute = guardsSleepLog[dependable]?.max { $0.value < $1.value }?.key ?? 0

print(dependable * dependablesMinute)
