//
//  String+Subscripts.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/3/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension StringProtocol {
    subscript(_ range: Range<Int>) -> SubSequence {
        let lowerBound = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upperBound = self.index(self.startIndex, offsetBy: range.upperBound)

        return self[lowerBound..<upperBound]
    }

    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        let lowerBound = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upperBound = self.index(self.startIndex, offsetBy: range.upperBound)

        return self[lowerBound...upperBound]
    }

    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        let lowerBound = self.index(self.startIndex, offsetBy: range.lowerBound)

        return self[lowerBound...]
    }

    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        let upperBound = self.index(self.startIndex, offsetBy: range.upperBound)

        return self[..<upperBound]
    }

    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        let upperBound = self.index(self.startIndex, offsetBy: range.upperBound)

        return self[...upperBound]
    }
}
