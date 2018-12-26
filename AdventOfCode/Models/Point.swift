//
//  Point
//  AdventOfCode
//
//  Created by Eric Cormack on 12/3/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public struct Point {
    public let x: Int
    public let y: Int

    public var manhattanNeighbors: [Point] {
        return [north, west, east, south]
    }

    public var manhattanMagnitude: Int { return abs(x + y) }

    public var adjacentPoints: [Point] {
        return
            [Point(x: x - 1, y: y - 1), north,
            Point(x: x + 1, y: y - 1), west,
            east, Point(x: x - 1, y: y + 1),
            south, Point(x: x + 1, y: y + 1)]
    }

    public static let origin = Point(x: 0, y: 0)

    public var north: Point { return Point(x: x, y: y - 1) }
    public var east: Point { return Point(x: x + 1, y: y) }
    public var south: Point { return Point(x: x, y: y + 1) }
    public var west: Point { return Point(x: x - 1, y: y) }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init?(from string: String) {
        let components = string.components(separatedBy: .punctuationCharacters).compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard components.count == 2 else { return nil }

        x = components[0]
        y = components[1]
    }

    public func isIn<Ranges>(xs: Ranges, ys: Ranges) -> Bool where Ranges: RangeExpression, Ranges.Bound == Int {
        return xs.contains(x) && ys.contains(y)
    }

    public func manhattanDistance(from that: Point) -> Int {
        return abs(self.x - that.x) + abs(self.y - that.y)
    }

    public func neighbor(toThe heading: Heading) -> Point {
        switch heading {
        case .North: return north
        case .East: return east
        case .South: return south
        case .West: return west
        }
    }

    // Addition
    public static func +(this: Point, that: Point) -> Point {
        return Point(x: this.x + that.x, y: this.y + that.y)
    }

    public static func +(this: Point, that: (x: Int, y: Int)) -> Point {
        return this + Point(x: that.x, y: that.y)
    }

    public static func +(this: (x: Int, y: Int), that: Point) -> Point {
        return that + this
    }

    // Subtraction
    public static func -(this: Point, that: Point) -> Point {
        return Point(x: this.x - that.x, y: this.y - that.y)
    }

    public static func -(this: Point, that: (x: Int, y: Int)) -> Point {
        return this - Point(x: that.x, y: that.y)
    }

    public static func -(this: (x: Int, y: Int), that: Point) -> Point {
        return that - this
    }

    // Scalar multiplication
    public static func *(scalar: Int, point: Point) -> Point {
        return Point(x: scalar * point.x, y: scalar * point.y)
    }

    // Range
    public static func ...(this: Point, that: Point) -> [Point] {
        guard this <= that else { return [] }

        return
            (this.y...that.y).flatMap { y in (this.x...that.x).map { x in Point(x: x, y: y) } }
    }
}

extension Point: Hashable {
    public static func ==(this: Point, that: Point) -> Bool {
        return this.x == that.x && this.y == that.y
    }

    public var hashValue: Int {
        return y << 16 + x
    }
}

extension Point: Comparable {
    public static func <(this: Point, that: Point) -> Bool {
        if this.y < that.y { return true }
        return this.y == that.y && this.x < that.x
    }

    public static func ==(this: Point, that: (x: Int, y: Int)) -> Bool {
        return this.x == that.x && this.y == that.y
    }

    public static func !=(this: Point, that: (x: Int, y: Int)) -> Bool {
        return !(this == that)
    }

    public static func ==(this: (x: Int, y: Int), that: Point) -> Bool {
        return that == this
    }

    public static func !=(this: (x: Int, y: Int), that: Point) -> Bool {
        return !(that == this)
    }

    public static func ~=(pattern: (x: Int, y: Int), value: Point) -> Bool {
        return pattern == value
    }

    public static func ~=(pattern: Point, value: (x: Int, y: Int)) -> Bool {
        return value == pattern
    }

    public func unapply() -> (x: Int, y: Int) {
        return (self.x, self.y)
    }
}

public func ~=(this: (x: Int, y: Int), that: (x: Int, y: Int)) -> Bool {
    return this.x == that.x && this.y == that.y
}

extension Point: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}
