import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "18", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
""".components(separatedBy: .newlines)

let input =
//    parse(sample)
    parse(stream)

let result = evolve(area: input, over: 1_000_000_000)
let maps = Dictionary(grouping: result.keys, by: { result[$0] ?? 0 }).mapValues({ $0.first ?? "" }).filter({ $0.value != "" })

let loop = 453 - 425
let target = 1_000_000_000 - 425

let mod = target % loop
let map = maps[mod + 425] ?? "None"

print(map)

print("Land value:", map.count(of: "#") * map.count(of: "|"))
