//
//  Indeterminate.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/3/19.
//  Copyright © 2019 the Odin Spire. All rights reserved.
//

import Foundation

public struct Indeterminate {
    var variables: Counter<String>

    init(_ variable: String, toThe power: Int = 1) {
        variables = [variable: power]
    }

    init(_ variables: Counter<String>) {
        self.variables = variables
    }

    static func *(this: Indeterminate, that: Indeterminate) -> Indeterminate {
        return Indeterminate(this.variables.adding(that.variables))
    }
}
