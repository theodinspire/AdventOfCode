//
//  Int+Modulo.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/9/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Int {
    func modulo(_ divisor: Int) -> Int {
        let remainder = self % divisor

        switch (remainder.signum(), divisor.signum()) {
        case (-1, 1):
            return remainder + divisor
        case (-1, -1):
            return remainder - divisor
        default:
            return remainder
        }
    }
}
