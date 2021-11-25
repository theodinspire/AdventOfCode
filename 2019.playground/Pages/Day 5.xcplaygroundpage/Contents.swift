//: [Previous](@previous)

import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "2", withExtension: "txt"),
	let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

guard let line = stream.nextLine() else { fatalError("Check input contents") }

let input = line.components(separatedBy: .punctuationCharacters).compactMap(Int.init)

enum ParameterMode: Int {
	case Position = 0
	case Immediate = 1
}

class IntcodeComputer {
	var memory: [Int]
}

protocol Operation {
	let operactionCode: Int
	let operationWidth: Int

	let parameterModes: [ParameterMode]

	protected func performOperation(on memory: inout [Int], atPosition position: Int) -> Void

	protected func nextAddress() -> Int?
}

extension Operation {
	func execute(on memory: inout [Int], atPosition position: Int) -> Int? {
		self.performOperation(on: &memory, atPosition: position)
		return self.nextAddress()
	}
}

//: [Next](@next)
