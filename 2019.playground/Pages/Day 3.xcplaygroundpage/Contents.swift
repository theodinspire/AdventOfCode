//: [Previous](@previous)

import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "3", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let input = try String(contentsOf: filepath)

// Day 1
let example1 = """
R8,U5,L5,D3
U7,R6,D4,L4
"""

let example2 = """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
"""

let example3 = """
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
"""

let inputPaths =
	input.intoPaths();
//	example1.intoPaths()
//	example2.intoPaths()
//	example3.intoPaths()

let first = inputPaths[0]
let second = inputPaths[1]
let inputIntersections = Set(first).intersection(Set(second))

print(first.count)

//print(inputIntersections.map({ $0.manhattanMagnitude }).min() ?? Int.max)

// Part 2
let a = Day3Helper.intersectionDistances(for: first, at: inputIntersections)
let b = Day3Helper.intersectionDistances(for: second, at: inputIntersections)

var shortestDistance = Int.max

for key in a.keys {
	guard let this = a[key], let that = b[key] else { continue }
	shortestDistance = min(shortestDistance, this + that)
}

print(shortestDistance)

//: [Next](@next)
