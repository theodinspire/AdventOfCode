//
//  Point3D.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/26/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public struct Point3D {
    public let x: Int
    public let y: Int
    public let z: Int

    public var manhattanMagnitude: Int {
        return abs(x) + abs(y) + abs(z)
    }

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init?(from string: String) {
        let components = string.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard components.count == 3 else { return nil }

        x = components[0]
        y = components[1]
        z = components[2]
    }

    public static func +(this: Point3D, that: Point3D) -> Point3D {
        return Point3D(x: this.x + that.x, y: this.y + that.y, z: this.z + that.z)
    }

    public static func -(this: Point3D, that: Point3D) -> Point3D {
        return Point3D(x: this.x - that.x, y: this.y - that.y, z: this.z - that.z)
    }
}
