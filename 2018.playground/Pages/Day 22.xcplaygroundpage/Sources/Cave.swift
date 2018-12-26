import Foundation
import AdventOfCode

public class Cave {
    let yCoefficient = 48271
    let xCoefficient = 16807

    let erosion = 20183

    let target: Point
    let depth: Int

    var geologicIndices: [Point : Int]
    var erosionLevels: [Point : Int]
    var terrain: [Point : Terrain]

    public init(targeting target: Point, delving depth: Int) {
        self.target = target
        self.depth = depth
        geologicIndices = [Point.origin : 0, target : 0]
        erosionLevels = [Point.origin : 0, target : 0]
        terrain = [Point.origin : .Rocky, target : .Rocky]
    }

    func geologicalIndex(at point: Point) -> Int {
        if let index = geologicIndices[point] { return index }
        guard point.x >= 0, point.y >= 0 else { return 0 }

        let index: Int

        switch (point.x, point.y) {
        case Point.origin, target:
            index = 0
        case let (x, 0):
            index = x * xCoefficient
        case let (0, y):
            index = y * yCoefficient
        default:
            index = erosionLevel(at: point.north) * erosionLevel(at: point.west)
        }

        geologicIndices[point] = index
        return index
    }

    func erosionLevel(at point: Point) -> Int {
        if let level = erosionLevels[point] { return level }
        let level = (geologicalIndex(at: point) + depth) % erosion
        erosionLevels[point] = level
        return level
    }

    public func terrain(at point: Point) -> Terrain {
        if let terrainType = terrain[point] { return terrainType }
        let terrainType = Terrain(from: erosionLevel(at: point))
        terrain[point] = terrainType
        return terrainType
    }

    public struct Visit: Hashable {
        public let location: Point
        public let tool: Equipment

        public var hashValue: Int { return tool.hashValue &* 37 &+ location.hashValue }

        public static func ==(this: Visit, that: Visit) -> Bool {
            return this.location == that.location && this.tool == that.tool
        }
    }

    typealias Node = (visit: Visit, time: Int)

    public func rescueTime(to point: Point) -> Int {
        let start = Visit(location: Point.origin, tool: .Torch)
        let end = Visit(location: target, tool: .Torch)

        var visited = Set<Visit>()
        var queue = Heap(using: { (this: Node, that: Node) -> Bool in
            if this.time != that.time { return this.time < that.time }

            return (this.visit.location - point).manhattanMagnitude <
                (that.visit.location - point).manhattanMagnitude
        })

        queue.add((start, 0))

        var iteration = 1

        while let current = queue.poll() {
            defer {
                if iteration % 10_000 ==  0 { print("Iteration", iteration) }
                iteration += 1
            }

            if current.visit == end {
                return current.time
            }

            let visit = current.visit

            guard visited.doesNotContain(visit) else { continue }
            defer { visited.insert(visit) }

            neighbors: for neighbor in visit.location.manhattanNeighbors {
                guard neighbor.x >= 0, neighbor.y >= 0 else { continue neighbors }

                let terrainType = terrain(at: neighbor)
                guard visit.tool.allowed(in: terrainType) else { continue neighbors }

                let next = Visit(location: neighbor, tool: visit.tool)
                guard visited.doesNotContain(next) else { continue neighbors }

                queue.add((next, current.time + 1))
            }

            let terrainType = terrain(at: visit.location)
            let next = Visit(location: visit.location, tool: visit.tool.otherAvailable(in: terrainType))

            guard visited.doesNotContain(next) else { continue }
            queue.add((next, current.time + 7))
        }

        return 0
    }
}
