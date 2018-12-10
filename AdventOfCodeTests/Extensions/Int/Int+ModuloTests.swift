//
//  Int+ModuloTests.swift
//  AdventOfCodeTests
//
//  Created by Eric Cormack on 12/9/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import XCTest
@testable import AdventOfCode

class IntModuloExtensionTests: XCTestCase {
    func testModulo_PositiveModuloItselfIsZero() {
        let n = Int.random(in: 1...Int.max)

        XCTAssertEqual(0, n.modulo(n))
    }

    func testModulo_TenModuloSevenIsThree() {
        XCTAssertEqual(3, 10.modulo(7))
    }

    func testModulo_NegativeTenModuloSevenIsFour() {
        XCTAssertEqual(4, (-10).modulo(7))
    }

    func testModulo_TenModuloNegativeSevenIsThree() {
        XCTAssertEqual(3, 10.modulo(-7))
    }

    func testModulo_NegativeTenModuloNegativeSevenIsFour() {
        XCTAssertEqual(4, (-10).modulo(-7))
    }

    func testModulo_ZeroModuloNotZeroIsZero() {
        XCTAssertEqual(0, 0.modulo(83))
    }
}
