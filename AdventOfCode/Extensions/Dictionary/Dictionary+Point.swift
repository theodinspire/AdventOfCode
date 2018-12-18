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
