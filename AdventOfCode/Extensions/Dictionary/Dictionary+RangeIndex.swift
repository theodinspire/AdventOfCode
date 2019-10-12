//
//  Dictionary+RangeIndex.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/12/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension Dictionary {
    subscript<RangeType>(_ range: RangeType) -> [Value?]
        where RangeType: Collection, RangeType: RangeExpression, RangeType.Element == Key {
            return range.map { self[$0] }
    }

    subscript<RangeType>(_ range: RangeType, default defaultValue: Value) -> [Value]
        where RangeType: Collection, RangeType: RangeExpression, RangeType.Element == Key {
        return range.map { self[$0, default: defaultValue] }
    }
}
