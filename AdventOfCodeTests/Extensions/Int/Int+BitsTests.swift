//
//  Int+BitsTests.swift
//  AdventOfCodeTests
//
//  Created by Eric Cormack on 12/9/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import XCTest
@testable import AdventOfCode

class IntBitsExtensionTests: XCTestCase {
    func testMostSignificantBit_TheMSVofZeroIsItself() {
        XCTAssertEqual(0, 0.mostSignificantBit)
    }

    func testMostSignificantBit_TheMSBofAPowerOfTwoIsEqualToItself() {
        for e in 0..<64 {
            let i = 1 << e
            XCTAssertEqual(i, i.mostSignificantBit)
        }
    }

    func testMostSignificantBit_NineThroughFifteenHaveEightAsTheirMSB() {
        for i in 9...15 {
            XCTAssertEqual(8, i.mostSignificantBit)
        }
    }
}
