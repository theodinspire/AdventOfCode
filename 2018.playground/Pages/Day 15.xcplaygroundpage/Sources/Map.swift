import Foundation
import AdventOfCode

public class Map {
    public let terrain: Set<Point>
    public let range: (x: ClosedRange<Int>, y: ClosedRange<Int>)
    public private(set) var units = [Unit]()
    public var elves: [Unit] { return units.filter({ $0.race == .Elf }) }
    public var goblins: [Unit] { return units.filter({ $0.race == .Goblin }) }

    public var occupiedSpaces: Set<Point> { return terrain.union(units.map { $0.position }) }
    public var unoccupiedSpaces: Set<Point> { return fullMap.subtracting(occupiedSpaces) }

    public let fullMap: Set<Point>

    public init(from lines: [String], elvesHavingPower elfPower: Int = 3) {
        var terrain = Set<Point>()
        var fullMap = Set<Point>(minimumCapacity: lines.count * lines[0].count)

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                fullMap.insert(point)

                switch character {
                case "#":
                    terrain.insert(point)
                case "E":
                    guard let race = Race(rawValue: character) else { break }
                    units.append(Unit(race, at: point, withPower: elfPower))
                case "G":
                    guard let race = Race(rawValue: character) else { break }
                    units.append(Unit(race, at: point))
                default:
                    break
                }
            }
        }

        self.terrain = terrain
        self.range = (1...lines[0].count, 1...lines.count)
        self.fullMap = fullMap

        defer {
            for unit in units { unit.map = self }
        }
    }

    public func generateASCIIMap(replacingWith items: [(point: Point, character: Character)] = []) -> String {
        let emptySpace: Character = " "
        var map = Array(repeating: Array(repeating: emptySpace, count: range.x.upperBound), count: range.y.upperBound)

        for point in terrain { map[point.y][point.x] = "#" }
        for unit in units { map[unit.position.y][unit.position.x] = unit.race.rawValue }

        for (point, item) in items {
            map[point.y][point.x] = item
        }

        return map.map { String($0) }.joined(separator: "\n")
    }

    public func hasUnoccupiedSpace(at point: Point) -> Bool {
        return !occupiedSpaces.contains(point)
    }

    public func unit(at point: Point) -> Unit? {
        return units.first(where: { $0.position == point })
    }

    public func remove(unit: Unit) {
        units.removeAll(where: { $0.id == unit.id })
    }

    public func takeTurn() -> Bool {
        guard elves.count > 0 && goblins.count > 0 else { return false }
        units.sort { $0.position < $1.position }

        defer {
            units.removeAll(where: { $0.isDead })
        }

        for unit in units {
            guard elves.count > 0 && goblins.count > 0 else { return false }
            unit.hunt()
            unit.battle()
        }

        return true
    }

    public func wageWar() -> (turns: Int, livingUnits: [Unit]) {
        var turnsTaken = 0

        while takeTurn() {
            turnsTaken += 1
            if turnsTaken % 100 == 0 {
                print("\(turnsTaken) turns completed")
            }
        }

        return (turnsTaken, elves.count > 0 ? elves : goblins)
    }
}
