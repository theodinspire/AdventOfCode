import Foundation
import AdventOfCode

public enum Race: Character {
    case Elf = "E"
    case Goblin = "G"
    case Phantom = "."
}

public class Unit {
    private static var lastId = 0
    private static var nextId: Int {
        lastId += 1
        return lastId
    }

    public private(set) var position: Point
    public let race: Race
    public let id: Int
    public weak var map: Map!

    private let power: Int
    public private(set) var health = 200

    public var isAlive: Bool { return health > 0 }
    public var isDead: Bool { return health <= 0 }

    public var measure: [Point] { return position.manhattanNeighbors }

    public init(_ race: Race, at position: Point, withPower power: Int = 3) {
        self.position = position
        self.race = race
        self.id = Unit.nextId
        self.power = power
        self.health = 200
    }

    public func findTarget() -> [Point] {
        guard isAlive, let map = map else { return [] }

        var unvisitedNodes = map.fullMap
        var previousNodes = [Point : Point]()

        var queue = Queue(startingWith: position)
        var target: Point?

        search: while let point = queue.dequeue() {
            for neighbor in point.manhattanNeighbors.filter({ unvisitedNodes.contains($0) }) {
                unvisitedNodes.remove(neighbor)
                previousNodes[neighbor] = point

                if map.hasUnoccupiedSpace(at: neighbor) {
                    queue.enqueue(neighbor)
                } else if let unit = map.unit(at: neighbor),
                    self.isOpponent(of: unit), unit.isAlive {
                    target = neighbor
                    break search
                }
            }
        }

        guard let end = target else { return [] }
        var list = [end]
        var next = end

        while let parent = previousNodes[next], parent != position {
            list.append(parent)
            next = parent
        }

        return list.reversed()
    }

    public func isOpponent(of that: Unit) -> Bool {
        switch (self.race, that.race) {
        case (.Elf, .Goblin), (.Goblin, .Elf): return true
        default: return false
        }
    }

    public func hunt() {
        guard let next = findTarget().first, map?.hasUnoccupiedSpace(at: next) ?? false else { return }
        position = next
    }

    public func battle() {
        guard isAlive,
            let victim = position.manhattanNeighbors
                .compactMap({ map.unit(at: $0) })
                .filter({ self.isOpponent(of: $0)})
                .sorted(by: { $0.health < $1.health })
                .first else { return }
        attack(opponent: victim)
    }

    private func attack(opponent: Unit) {
        opponent.take(damage: self.power)
    }

    public func take(damage: Int) {
        health -= damage

        if isDead {
            position = Point(x: Int.max, y: Int.max)
            map.remove(unit: self)
        }
    }
}
