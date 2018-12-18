import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "17", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
""".components(separatedBy: .newlines)

let input =
    sample
//    stream
        .compactMap(parse).flatMap({ $0 })

let spring = Point(x: 500, y: 0)
var map = input.reduce(into: [spring : Fill.Spring]) { $0[$1] = .Clay }

print(generateChart(from: map))
