import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "10", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = """
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
""".components(separatedBy: .newlines)

typealias Velocity = Point

struct Flare {
    static let regex = Regex("position=<\\s*(-?\\d+),\\s*(-?\\d+)> velocity=<\\s*(-?\\d+),\\s*(-?\\d+)>")

    let position: Point
    let velocity: Velocity

    func position(after seconds: Int) -> Point {
        return position + (seconds * velocity)
    }

    init(position: Point, velocity: Velocity) {
        self.position = position
        self.velocity = velocity
    }

    init?(from string: String) {
        guard let matches = Flare.regex.firstMatch(in: string)?.captures.compacted().compactMap(Int.init), matches.count == 4 else { return nil }

        self.position = Point(x: matches[0], y: matches[1])
        self.velocity = Velocity(x: matches[2], y: matches[3])
    }
}

let input =
//    sample
    stream
        .compactMap(Flare.init)

// Part 1
var timeElapsed = 0

var horizontal = 1...Int.max
var vertical = 1...Int.max

var positions = [Point]()
var delta = 1000

repeat {
    let points = input.map { $0.position(after: timeElapsed) }

    let bounds = points.reduce((xMin: Int.max, xMax: Int.min, yMin: Int.max, yMax: Int.min)) { bound, point in
        (min(bound.xMin, point.x),
         max(bound.xMax, point.x),
         min(bound.yMin, point.y),
         max(bound.yMax, point.y))
    }

    let xSpan = bounds.xMin...bounds.xMax
    let ySpan = bounds.yMin...bounds.yMax

    let lastDelta = delta

    if horizontal.count < xSpan.count, vertical.count < ySpan.count {
        delta /= -10
    }

    guard delta != 0 else {
        timeElapsed -= lastDelta
        break
    }

    horizontal = xSpan
    vertical = ySpan

    timeElapsed += delta
} while delta != 0

print(timeElapsed, horizontal, vertical)

let locations = input.map { $0.position(after: timeElapsed) }
let marks = locations.reduce(into: [Point : String]()) { $0[$1] = "#" }

for y in vertical {
    print(horizontal.map { x in marks[Point(x: x, y: y), default: " "] }.joined())
}
