//
//  Comparable+PairInOrder.swift
//  AdventOfCode
//
//  Created by Eric T Cormack on 8/28/20.
//  Copyright © 2020 the Odin Spire. All rights reserved.
//

import Foundation

public extension Comparable {
	static func orderingPair(_ this: Self, and that: Self) -> (lesser: Self, greater: Self) {
		if (this < that) {
			return (this, that)
		}

		return (that, this)
	}
}
