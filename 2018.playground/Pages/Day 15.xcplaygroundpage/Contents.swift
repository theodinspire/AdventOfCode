import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "15", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let input = Array(stream)

//let locationSample = """
//#######
//#.G.E.#
//#E.G.E#
//#.G.E.#
//#######
//""".components(separatedBy: .newlines)
//let locationSampleMap = Map(from: locationSample)
//print(locationSampleMap.generateASCIIMap())

//let targetingSample = """
//#######
//#E..G.#
//#...#.#
//#.G.#G#
//#######
//""".components(separatedBy: .newlines)
//let targetingMap = Map(from: targetingSample)
//print(targetingMap.generateASCIIMap())
//
//let path = targetingMap.units.first?.findTarget().filter({ targetingMap.hasUnoccupiedSpace(at: $0) }) ?? []
//print(path)
//
//print(targetingMap.generateASCIIMap(replacingWith: path.map({ ($0, ">") })))

//let movementSample = """
//#########
//#G..G..G#
//#.......#
//#.......#
//#G..E..G#
//#.......#
//#.......#
//#G..G..G#
//#########
//""".components(separatedBy: .newlines)
//let movementMap = Map(from: movementSample)
//
//movementMap.move()
//print(movementMap.generateASCIIMap())
//movementMap.move()
//print(movementMap.generateASCIIMap())
//movementMap.move()
//print(movementMap.generateASCIIMap())

let battleSample = """
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
""".components(separatedBy: .newlines)

let battleMap =
//    Map(from: battleSample)
    Map(from: input)

let targetElfCount = battleMap.elves.count

// Part 1
var results = battleMap.wageWar()
print(battleMap.generateASCIIMap())
print()
print("Winners:", results.livingUnits.first?.race ?? "No one")
print("Turns taken:", results.turns)
print("Life totals:", results.livingUnits.map({ $0.health }))
print(results.turns * results.livingUnits.reduce(0, { $0 + $1.health }))

// Part 2
var power = 3
var newMap: Map!

while results.livingUnits.first?.race == .Goblin || results.livingUnits.count != targetElfCount {
    power += 1
    newMap =
//        Map(from: battleSample, elvesHavingPower: power)
        Map(from: input, elvesHavingPower: power)
    results = newMap.wageWar()
}

print(newMap.generateASCIIMap())
print()
print("Winners:", results.livingUnits.first?.race ?? "No one")
print("Elf's attack power:", power)
print("Turns taken:", results.turns)
print("Life totals:", results.livingUnits.map({ $0.health }))
print(results.turns * results.livingUnits.reduce(0, { $0 + $1.health }))
