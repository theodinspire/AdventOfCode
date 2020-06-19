//
//  CounterTests.swift
//  AdventOfCodeTests
//
//  Created by Eric Cormack on 12/3/19.
//  Copyright © 2019 the Odin Spire. All rights reserved.
//

import XCTest
@testable import AdventOfCode

class CounterTests: XCTestCase {

    func testAdding_CombinesCountsOfItems() {
        // Arrange
        let item = "x"
        let first = Int.random(in: 1...10)
        let second = Int.random(in: 11...20)

        let this = [item: first]
        let that = [item: second]

        // Act
        let sut = this.adding(that);

        // Assert
        XCTAssertEqual(sut.occurences(of: item), first + second)
    }

    func testAdding_IncludesNewItems() {
        // Arrange
        let firstItem = "x"
        let secondItem = "y"

        let firstCount = Int.random(in: 1...10)
        let secondCount = Int.random(in: 11...20)

        let this = [firstItem: firstCount]
        let that = [secondItem: secondCount]

        // Act
        let sut = this.adding(that)

        // Assert
        XCTAssertEqual(sut.occurences(of: firstItem), firstCount)
        XCTAssertEqual(sut.occurences(of: secondItem), secondCount)
    }
}
