//
//  Collection+Compact.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/4/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

extension Collection {
    public func compacted<Type>() -> [Type] where Self.Element == Optional<Type> {
        return self.lazy.compactMap { $0 }
    }
}
