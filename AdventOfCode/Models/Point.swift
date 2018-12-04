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

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point: Hashable {
    public static func ==(this: Point, that: Point) -> Bool {
        return this.x == that.x && this.y == that.y
    }

    public var hashValue: Int {
        return x << 16 + y
    }
}
