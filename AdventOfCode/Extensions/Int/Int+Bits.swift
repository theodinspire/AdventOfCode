//
//  Int+Bits.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/9/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Int {
    public var mostSignificantBit: Int {
        guard self != 0 else { return 0 }
        return 1 << (bitWidth - leadingZeroBitCount - 1)
    }
}
