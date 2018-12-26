import Foundation
import AdventOfCode

public class Cave {
    let yCoefficient = 48271
    let xCoefficient = 16807

    let erosion = 20183

    let target: Point
    let depth: Int

    var geologicIndices: [Point : Int]

    public init(targeting target: Point, delving depth: Int) {
        self.target = target
        self.depth = depth
        geologicIndices = [Point.origin : 0, target : 0]
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
        return (geologicalIndex(at: point) + depth) % erosion
    }

    public func terrain(at point: Point) -> Terrain {
        return Terrain(from: erosionLevel(at: point))
    }
}
