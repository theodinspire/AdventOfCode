import Foundation
import AdventOfCode2018

guard let filepath = Bundle.main.url(forResource: "02", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }
let sample = [
    "abcde",
    "fghij",
    "klmno",
    "pqrst",
    "fguij",
    "axcye",
    "wvxyz"
]

let input = stream.filter { $0.count > 0 }

// Part 1
let counters = input.map { line in line.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 } }

let twos = counters.filter{ item in item.values.contains { $0 == 2 } }.count
let threes = counters.filter{ item in item.values.contains { $0 == 3 } }.count

print(twos * threes)

// Part 2
outer: for (i, this) in input.enumerated() {
    inner: for that in input[(i + 1)...] {
        let zipper = zip(this, that)

        guard (zipper.filter { $0.0 != $0.1 }).count == 1 else { continue inner }

        print("Box Ids: ", this, that)
        print("Common letters:", String(zipper.filter { $0.0 == $0.1 }.map { $0.0 }))

        break outer
    }
}
