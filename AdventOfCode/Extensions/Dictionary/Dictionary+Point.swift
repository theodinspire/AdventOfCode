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

        return (0...yMax).map { y in
            String((0...xMax).map { x in self[x, y, default: null].rawValue })
            }.joined(separator: "\n")
    }
}
