import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "06", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = [
    "1, 1",
    "1, 6",
    "8, 3",
    "3, 4",
    "5, 5",
    "8, 9"
]

let input =
//    sample.compactMap(Point.init)
    stream.compactMap(Point.init)

// Part 1
let tie = Point(x: Int.min, y: Int.min)

let xs = input.map { $0.x }
let ys = input.map { $0.y }

let horizontal = (xs.min() ?? 0)...(xs.max() ?? 400)
let vertical = (ys.min() ?? 0)...(ys.max() ?? 400)

//var domains = Dictionary(zip(input, input)) { a, _ in a }
//
//var visited = Set(input)
//
//var neighbors = Set(input.flatMap { $0.manhattanNeighbors }).subtracting(visited).filter { $0.isIn(xs: horizontal, ys: vertical)}
//
//repeat {
//    var newDomains = [Point : Point]()
//
//    for neighbor in neighbors {
//        let candidates = Set(neighbor.manhattanNeighbors.compactMap { domains[$0] }).filter { $0 != tie }
//        if candidates.count == 1, let parent = candidates.first {
//            newDomains[neighbor] = parent
//        } else {
//            newDomains[neighbor] = tie
//        }
//    }
//
//    newDomains.forEach { domains[$0] = $1 }
//    visited.formUnion(neighbors)
//
//    neighbors = Set(neighbors.flatMap { $0.manhattanNeighbors }).subtracting(visited).filter { $0.isIn(xs: horizontal, ys: vertical)}
//} while neighbors.count > 0
//
//let inifiniteDomains =
//    Set(horizontal.compactMap { domains[Point(x: $0, y: vertical.first ?? 0)] })
//        .union(horizontal.compactMap { domains[Point(x: $0, y: vertical.last ?? 400)] })
//        .union(vertical.compactMap { domains[Point(x: horizontal.first ?? 0, y: $0)] })
//        .union(vertical.compactMap { domains[Point(x: horizontal.last ?? 400, y: $0)] })
//
//let counts = domains.values.filter { !inifiniteDomains.contains($0) }.reduce(into: [Point : Int]()) { $0[$1, default: 0] += 1 }
//
//print(counts.values.max() ?? "0")

// Part 2
let target =
//    32
    10_000

let area = horizontal.flatMap{ x in vertical.map { y in Point(x: x, y: y) } }
        .map { point in input.map { point.manhattanDistance(from: $0) }.reduce(0, +) }
        .count(where: { $0 < target })

print(area)
