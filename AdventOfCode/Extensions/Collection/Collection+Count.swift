//
//  Sequence+Count.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/3/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Collection {
    func count(where predicate: (Element) -> Bool) -> Int {
        return self.reduce(0) { $0 + (predicate($1) ? 1 : 0) }
    }
}

public extension Collection where Element: Hashable {
    func count(of element: Element) -> Int {
        return self.reduce(0) { $0 + ($1 == element ? 1 : 0) }
    }
}
