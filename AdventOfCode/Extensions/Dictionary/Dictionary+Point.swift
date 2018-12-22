//
//  Dictionary+Point.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/17/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Dictionary where Key == Point {
    public subscript(_ x: Int, _ y: Int) -> Value? {
        get {
            return self[Point(x: x, y: y)]
        }
        set(newValue) {
            self[Point(x: x, y: y)] = newValue
        }
    }

    public subscript(_ x: Int, _ y: Int, default value: Value) -> Value {
        get {
            return self[Point(x: x, y: y), default: value]
        }
        set(newValue) {
            self[Point(x: x, y: y)] = newValue
        }
    }
}

public extension Dictionary where Key == Point, Value: RawRepresentable, Value.RawValue == Character {
    public func generateMap(defaultingTo null: Value) -> String {
        let (xMax, yMax) = self.keys.reduce((x: Int.min, y: Int.min)) {
                (Swift.max($0.x, $1.y), Swift.max($0.y, $1.y))
        }
        let (xMin, yMin) = self.keys.reduce((x: Int.max, y: Int.max)) {
            (Swift.min($0.x, $1.y), Swift.min($0.y, $1.y))
        }

        return (yMin...yMax).map { y in
            String((xMin...xMax).map { x in self[x, y, default: null].rawValue })
            }.joined(separator: "\n")
    }
}

public extension Dictionary where Key == Point, Value == Character {
    public func generateMap(defaultingTo null: Value) -> String {
        let (xMax, yMax) = self.keys.reduce((x: Int.min, y: Int.min)) {
            (Swift.max($0.x, $1.y), Swift.max($0.y, $1.y))
        }
        let (xMin, yMin) = self.keys.reduce((x: Int.max, y: Int.max)) {
            (Swift.min($0.x, $1.y), Swift.min($0.y, $1.y))
        }

        return (yMin...yMax).map { y in
            String((xMin...xMax).map { x in self[x, y, default: null] })
            }.joined(separator: "\n")
    }
}
