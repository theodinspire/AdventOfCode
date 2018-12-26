import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "22", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
depth: 510
target: 10,10
""".components(separatedBy: .newlines)

let input =
//    sample
    Array(stream)

let depthRegex = Regex("depth: (\\d+)")
let targetRegex = Regex("target: (\\d+,\\d+)")

guard let depthMatch = depthRegex.firstMatch(in: input[0])?.captures[0], let depth = Int(depthMatch) else { fatalError("Could not parse cave depth") }
guard let targetMatch = targetRegex.firstMatch(in: input[1])?.captures[0], let target = Point(from: targetMatch) else { fatalError("Could not parse target location") }

print(depth, target)

// Part 1
let cave = Cave(targeting: target, delving: depth)

print("Risk level:",
      (Point.origin...target).map { cave.terrain(at: $0).rawValue }.reduce(0, +))

// Part 2
print("Elapsed time:", cave.rescueTime(to: target))
