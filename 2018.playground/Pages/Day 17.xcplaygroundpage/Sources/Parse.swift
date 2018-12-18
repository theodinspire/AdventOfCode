import Foundation
import AdventOfCode

import Regex

let regex = Regex("^(x|y)=(\\d+), [xy]=(\\d+)..(\\d+)$")

public func parse(_ line: String) -> [Point]? {
    guard let captures = regex.firstMatch(in: line)?.captures.compacted(),
        captures.count == 4 else { return nil }

    let values = captures.compactMap(Int.init)
    let range = values[1]...values[2]

    if captures[0] == "x" {
        return range.map { Point(x: values[0], y: $0) }
    } else if captures[0] == "y" {
        return range.map { Point(x: $0, y: values[0]) }
    } else { return nil }
}
