import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "03", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

struct Claim {
    let id: Int

    let left: Int
    let top: Int

    let width: Int
    let height: Int

    var coveredPoints: [Point] {
        get { return (left..<(left + width)).flatMap { x in (top..<(top  + height)).map { Point(x: x, y: $0) } } }
    }

    static let mappingRegex = Regex("^#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)$")

    init?(from claimSlip: String) {
        guard let values = Claim.mappingRegex.firstMatch(in: claimSlip)?.captures.compactMap({ $0 }).compactMap(Int.init), values.count == 5 else { return nil }

        id = values[0]
        left = values[1]
        top = values[2]
        width = values[3]
        height = values[4]
    }
}

let sample = [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
    ]

let input =
//    sample.compactMap(Claim.init)
    stream.compactMap(Claim.init)

// Part 1
let cloth = input.lazy.reduce(into: Counter<Point>(), { $0.record(collection: $1.coveredPoints.lazy) })

let overlaps = cloth.values.lazy.count(where: { $0 > 1 })

print("Overlapping squares:", overlaps)

// Part 2
guard let target = input.lazy.first(where: { claim in claim.coveredPoints.lazy.allSatisfy({ cloth.occurences(of: $0) == 1 }) }) else {
    fatalError("There will be one claim that does not have overlaps")
}

print("Target claim id:", target.id)
