//
//  IndeterminateTests.swift
//  AdventOfCodeTests
//
//  Created by Eric Cormack on 12/3/19.
//  Copyright © 2019 the Odin Spire. All rights reserved.
//

import XCTest
@testable import AdventOfCode

class IndeterminateTests: XCTestCase {

    func testInitVariable_ContainsVariable() {
        // Arrange
        let variable = "x"

        // Act
        let sut = Indeterminate(variable)

        // Assert
        XCTAssertTrue(sut.variables.keys.contains(variable))
    }

    func testInitVariable_ContainsOnlyOneVariable() {
        // Act
        let sut = Indeterminate("x")

        // Assert
        XCTAssertEqual(sut.variables.keys.count, 1)
    }

    func testInitVariable_DefaultMakesOne() {
        // Arrange
        let variable = "x"

        // Act
        let sut = Indeterminate(variable)

        // Assert
        XCTAssertEqual(sut.variables[variable], 1)
    }

    func testInitVariable_InputedPowerIsUsed() {
        // Arrange
        let variable = "x"
        let power = Int.random(in: 1...Int.max)

        // Act
        let sut = Indeterminate(variable, toThe: power)

        // Assert
        XCTAssertEqual(sut.variables[variable], power)
    }

    func testInitVariables_ContainsAllVariables() {
        // Arrange
        let first = "x"
        let second = "y"

        // Act
        let sut = Indeterminate([first: 1, second: 1])

        // Assert
        XCTAssertTrue(sut.variables.keys.contains(first))
        XCTAssertTrue(sut.variables.keys.contains(second))
    }

    func testInitVariables_HasInputedValuesForVariables() {
        // Arrange
        let firstVariable = "x"
        let secondVariable = "y"

        let firstPower = Int.random(in: 1...Int.max)
        let secondPower = Int.random(in: 1...Int.max)

        let variables = [
            firstVariable: firstPower,
            secondVariable: secondPower
        ]

        // Act
        let sut = Indeterminate(variables)

        // Assert
        XCTAssertEqual(sut.variables[firstVariable], firstPower)
        XCTAssertEqual(sut.variables[secondVariable], secondPower)
    }

    func testMultiplication_PowersWillCombine() {
        // Arrange
        let variable = "x"
        let thisPower = Int.random(in: 1...10)
        let thatPower = Int.random(in: 11...20)

        let this = Indeterminate(variable, toThe: thisPower)
        let that = Indeterminate(variable, toThe: thatPower)

        // Act
        let sut = this * that

        // Assert
        XCTAssertEqual(sut.variables[variable], thisPower + thatPower)
    }

    func testMultiplication_IndependantVariablesAreAddedAsIs() {
        // Arrange
        let thisVariable = "x"
        let thatVariable = "y"
        let thisPower = Int.random(in: 1...10)
        let thatPower = Int.random(in: 11...20)

        let this = Indeterminate(thisVariable, toThe: thisPower)
        let that = Indeterminate(thatVariable, toThe: thatPower)

        // Act
        let sut = this * that

        // Assert
        XCTAssertEqual(sut.variables[thisVariable], thisPower)
        XCTAssertEqual(sut.variables[thatVariable], thatPower)
    }
}
