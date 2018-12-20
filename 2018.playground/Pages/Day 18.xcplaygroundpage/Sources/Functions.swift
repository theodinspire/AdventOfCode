import Foundation
import AdventOfCode

public func parse<Source>(_ source: Source) -> [Point : LandUse] where Source: Sequence, Source.Element == String {
    var output = [Point : LandUse]()

    for (y, line) in source.enumerated() {
        for (x, character) in line.enumerated() {
            output[x, y] = LandUse.init(rawValue: character)
        }
    }

    return output
}

public func evolve(area: [Point: LandUse], over generations: Int) -> [String : Int] {
    var maps = [area.generateMap(defaultingTo: .Open) : 0]

    var result = area

    for generation in 1...generations {
        var temp = [Point : LandUse]()

        for (point, use) in result {
            let neighbors = point.adjacentPoints.compactMap { result[$0] }

            switch use {
            case .Open:
                temp[point] = neighbors
                    .count(of: .Forest) >= 3 ? .Forest : .Open
            case .Forest:
                temp[point] = neighbors
                    .count(of: .Lumberyard) >= 3 ? .Lumberyard : .Forest
            case .Lumberyard:
                temp[point] =
                    (neighbors.contains(.Forest) && neighbors.contains(.Lumberyard)) ?
                        .Lumberyard : .Open
            }
        }

        let current = temp.generateMap(defaultingTo: .Open)

        if maps.keys.contains(current) {
            print("Stable arrangement established after \(generation - 1) generations")
            print("Loops back to generation", maps[current] ?? -1)
            break
        }

        if generation % 1_000 == 0 {
            print("Generation", generation, "out of", generations)
        }

        result = temp
        maps[current] = generation
    }

    return maps
}
