//  Collection+Sum.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/2/19.
//  Copyright © 2019 the Odin Spire. All rights reserved.
//

import Foundation

public extension Collection where Element: Numeric {
    func sum() -> Element {
        return self.reduce(0, +)
    }
}
