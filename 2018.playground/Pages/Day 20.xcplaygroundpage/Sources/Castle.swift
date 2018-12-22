import Foundation
import AdventOfCode

public class Room {
    private static var nextId = 0
    private static func getId() -> Int {
        nextId += 1
        return nextId
    }

    public let location: Point
    public let id: Int
    public var neighbors = [Heading : Room]()

    public init(at point: Point) {
        location = point
        id = Room.getId()
    }

    public func join(neighbor: Room, directed heading: Heading) {
        neighbors[heading] = neighbor
        neighbor.neighbors[heading.opposite] = self
    }
}

extension Room: Hashable {
    public var hashValue: Int { return id.hashValue }

    public static func ==(this: Room, that: Room) -> Bool {
        return this.id == that.id
    }
}

public class Castle {
    public let rooms: [Point : Room]
    public let home: Room

    public init(from regularExpression: String) {
        let startingPoint = Point(x: 0, y: 0)
        home = Room(at: startingPoint)

        var castle = [startingPoint : home]

        var branchStack = [Room]()
        var currentRoom = home

        mapping: for character in regularExpression {
            switch character {
            case "^":
                break
            case "$":
                break mapping

            case "N", "E", "S", "W":
                guard let heading = Heading(rawValue: character) else { break }

                let nextPoint = currentRoom.location.neighbor(toThe: heading)
                let nextRoom: Room

                if let next = castle[nextPoint] {
                    nextRoom = next
                } else {
                    nextRoom = Room(at: nextPoint)
                    castle[nextPoint] = nextRoom
                }

                currentRoom.join(neighbor: nextRoom, directed: heading)

                currentRoom = nextRoom

            case "(":
                branchStack.append(currentRoom)
            case ")":
                currentRoom = branchStack.removeLast()
            case "|":
                currentRoom = branchStack.last!
            default:
                break
            }
        }

        rooms = castle
    }

    public func printFloorPlan() {
        var map = [Point : Character]()

        for (location, room) in rooms {
            let point = 2 * location
            map[point] = " "
            for heading in room.neighbors.keys {
                switch heading {
                case .North, .South:
                    map[point.neighbor(toThe: heading)] = "—"
                case .East, .West:
                    map[point.neighbor(toThe: heading)] = "|"
                }
            }
        }

        map[home.location] = "x"

        let xes = map.keys.map { $0.x }
        let wyes = map.keys.map { $0.y }

        map[xes.min()! - 1, wyes.min()! - 1] = "#"
        map[xes.max()! + 1, wyes.max()! + 1] = "#"

        //        print(map)
        print(map.generateMap(defaultingTo: "#"))
    }

    public func longestPath() -> Int {
        return getDepths().values.max() ?? 0
    }

    public func getDepths() -> [Room : Int] {
        var depths = [home : 0]
        var parents = home.neighbors.values.reduce(into: [Room : Room]()) { $0[$1] = home }

        var queue = Array(home.neighbors.values)

        while queue.count > 0 {
            let room = queue.removeFirst()
            depths[room] = depths[parents[room]!]! + 1

            for neighbor in room.neighbors.values.filter({ !parents.keys.contains($0) }) {
                parents[neighbor] = room
                queue.append(neighbor)
            }
        }

        return depths
    }
}
