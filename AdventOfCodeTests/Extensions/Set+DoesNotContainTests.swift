//
//  Set+DoesNotContainTests.swift
//  AdventOfCodeTests
//
//  Created by Eric Cormack on 12/25/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import XCTest

class SetDoesNotContainTests: XCTestCase {

    func testDoesNotContain_ReturnsFalseForContainedItem() {
        let sut: Set<Int> = [1]

        XCTAssertFalse(sut.doesNotContain(1))
    }

    func testDoesNotContain_ReturnsTrueForAbsentItem() {
        let sut = Set<Int>()

        XCTAssertTrue(sut.doesNotContain(1))
    }

}
