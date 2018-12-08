import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "07", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = [
    "Step C must be finished before step A can begin.",
    "Step C must be finished before step F can begin.",
    "Step A must be finished before step B can begin.",
    "Step A must be finished before step D can begin.",
    "Step B must be finished before step E can begin.",
    "Step D must be finished before step E can begin.",
    "Step F must be finished before step E can begin."
]

let pattern = Regex("Step ([A-Z]) must be finished before step ([A-Z]) can begin.")

// Sample switch
let isSample =
//    true
    false

let input = (isSample ? (AnySequence(sample)) : (AnySequence(stream)))
        .compactMap { pattern.firstMatch(in: $0)?.captures.compacted() }

// Part 1
var remainingSteps = Set(input.flatMap { $0 })

let nextSteps = input.lazy
    .map({ (previous: $0[0], subsequent: $0[1]) })
    .reduce(into: [String : Set<String>]()) {
        $0[$1.previous, default: []].insert($1.subsequent)
}

let previousSteps = input.lazy
    .map({ (previous: $0[0], subsequent: $0[1]) })
    .reduce(into: [String : Set<String>]()) {
        $0[$1.subsequent, default: []].insert($1.previous)
}

var dependencies = previousSteps

var order = [String]()

while let next = remainingSteps.subtracting(dependencies.keys).min() {
    defer {
        let _ = remainingSteps.remove(next)
        order.append(next)
    }

    for step in nextSteps[next] ?? [] {
        dependencies[step]?.remove(next)
        if dependencies[step]?.isEmpty ?? false { let _ = dependencies.removeValue(forKey: step) }
    }
}

print(order.joined())

// Part 2
remainingSteps = Set(input.flatMap { $0 })
dependencies = previousSteps

// 65 is the ASCII value for A
let timeTranslation = 64 - (isSample ? 0 : 60)
let totalElves = isSample ? 2 : 5

let timeValues = order.reduce(into: [String : Int]()) { dictionary, key in
    guard let value = key.unicodeScalars.first?.value else { return }
    dictionary[key] = Int(value) - timeTranslation
}

var timeSpent = 0
var currentSteps = [String : Int](minimumCapacity: totalElves)

//for _ in 1...6 {
repeat {
    stepping: for step in remainingSteps.subtracting(dependencies.keys).sorted(by: <).makeIterator() {
        guard currentSteps.count < totalElves else { break stepping }
        currentSteps[step] = timeValues[step] ?? 0
        let _ = remainingSteps.remove(step)
    }

//    var iterator = remainingSteps.subtracting(dependencies.keys).sorted(by: <).makeIterator()
//    while currentSteps.count < totalElves, let step = iterator.next() {
//        currentSteps[step] = timeValues[step] ?? 0
//        let _ = remainingSteps.remove(step)
//    }

    guard let (next, time) = currentSteps.min(by: { $0.value < $1.value }) else { break }

    for step in nextSteps[next] ?? [] {
        dependencies[step]?.remove(next)
        if dependencies[step]?.isEmpty ?? false { let _ = dependencies.removeValue(forKey: step) }
    }

    let _ = currentSteps.removeValue(forKey: next)

    for (key, value) in currentSteps { currentSteps[key] = value - time }

    timeSpent += time
//}
} while !currentSteps.isEmpty || !remainingSteps.isEmpty

print("Time spent:", timeSpent)
