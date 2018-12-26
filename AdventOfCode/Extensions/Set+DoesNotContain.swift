//
//  Set+DoesNotContain.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/25/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Set {
    func doesNotContain(_ element: Element) -> Bool {
        return !self.contains(element)
    }
}
