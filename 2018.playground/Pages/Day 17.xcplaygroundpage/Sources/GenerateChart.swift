import Foundation
import AdventOfCode

public func generateChart(from map: [Point : Fill]) -> String {
    let xMin = (map.keys.map({ $0.x }).min() ?? 500) - 1
    let xMax = (map.keys.map({ $0.x }).max() ?? 500) + 1
    let yMax = map.keys.map({ $0.y }).max() ?? 0

    var lines = [String]()

    for y in 0...yMax {
        lines.append(
            String((xMin...xMax)
                .map({ x in map[x, y, default: .Sand].rawValue })))
    }

    return lines.joined(separator: "\n")
}
