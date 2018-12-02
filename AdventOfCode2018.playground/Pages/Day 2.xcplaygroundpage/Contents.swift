import Foundation
import AdventOfCode2018

guard let filepath = Bundle.main.url(forResource: "02", withExtension: "txt"),
    let input = StreamReader(url: filepath) else { abort() }
let sample = [
    "abcdef",
    "bababc",
    "abbcde",
    "abcccd",
    "aabcdd",
    "abcdee",
    "ababab"
]

// Part 1
let counters = input.map { (line: String) -> [Character: Int] in
    return line.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
}

let twos = counters.filter{ (item: [Character: Int]) -> Bool in
    item.values.contains { $0 == 2 }
}.count
let threes = counters.filter{ (item: [Character: Int]) -> Bool in
    item.values.contains { $0 == 3 }
}.count

print(twos * threes)
