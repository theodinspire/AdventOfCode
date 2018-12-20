import Foundation
import AdventOfCode

import Regex

public class Hydrology {
    static let regex = Regex("^(x|y)=(\\d+), [xy]=(\\d+)..(\\d+)$")

    public let source: Point
    public var map: [Point : Fill]
    public let yMax: Int
    public let yMin: Int

    public var spring: Flow? = nil

    public var stack = [() -> Void]()

    public var saturatedCount: Int {
        return map.filter({
            ($0.value == .StandingWater || $0.value == .FlowingWater)
                && (yMin...yMax).contains($0.key.y)
        }).count
    }

    public init<Source>(springingFrom source: Point, from input: Source) where Source: Sequence, Source.Element == String {
        self.source = source
        let map = input
            .compactMap(Hydrology.parse)
            .flatMap { $0 }
            .reduce(into: [source : Fill.Spring]) { $0[$1] = .Clay }

        self.map = map

        let yMax = map.keys.reduce(0) { max($0, $1.y) }
        self.yMax = yMax
        yMin = map.filter({ $0.value == .Clay}).lazy.map({ $0.key.y }).min() ?? yMax
    }

    public static func parse(_ line: String) -> [Point]? {
        guard let captures = regex.firstMatch(in: line)?.captures.compacted(),
            captures.count == 4 else { return nil }

        let values = captures.compactMap(Int.init)
        let range = values[1]...values[2]

        if captures[0] == "x" {
            return range.map { Point(x: values[0], y: $0) }
        } else if captures[0] == "y" {
            return range.map { Point(x: $0, y: values[0]) }
        } else {
            print("Line did not parse:", line)
            return nil
        }
    }

    public func generateChart() -> String {
        let xMin = (map.keys.map({ $0.x }).min() ?? 500) - 1
        let xMax = (map.keys.map({ $0.x }).max() ?? 500) + 1

        var lines = [String]()

        for y in 0...yMax {
            lines.append(
                String((xMin...xMax)
                    .map({ x in map[x, y, default: .Sand].rawValue })))
        }

        return lines.joined(separator: "\n")
    }

    public func flow() {
        spring = Flow(to: source, in: self)
        stack.append(spring!.seep)

        var count = 1
        while stack.count > 0 {
            stack.removeLast()()

            if count % 10_000 == 0 { print("Flow step \(count)") }
            count += 1
        }
    }
}
