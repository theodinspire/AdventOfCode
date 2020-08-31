//: [Previous](@previous)

import Foundation
import AdventOfCode

typealias Predicate<T> = (T) -> Bool

guard let filepath = Bundle.main.url(forResource: "4", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let input = try String(contentsOf: filepath).trimmingCharacters(in: .newlines).components(separatedBy: .punctuationCharacters)

guard let start = Int(input[0]), let end = Int(input[1]) else {
	fatalError("Could not parse input")
}

let range = (start...end).map { Helper.digitArray(from: $0) }

func digitArray(from number: Int, ofLength length: Int = 6) -> [Int] {
	guard number > 0 else { return [] }

	var array = Array(repeating: 0, count: length)
	var tmp = number

	for i in (0..<length).reversed() {
		array[i] = tmp % 10
		tmp /= 10
	}

	return array
}

let doubledNumber: Predicate<[Int]> = { array in
	for i in 1..<array.count {
		if array[i] == array[i - 1] { return true }
	}
	return false
}

let alwaysIncreasing: Predicate<[Int]> = { array in
	for i in 1..<array.count {
		if array[i] < array[i - 1] { return false }
	}
	return true
}

//let predicates = [alwaysIncreasing, doubledNumber]
//let countSatisfy = range.count(where: { i in predicates.allSatisfy { $0(i) } })

//print(countSatisfy)

// Part 2
let hasANumberInSomeGroupOfOnlyTwo: Predicate<[Int]> = { array in
	var lastNumber = -1
	var currentCount = 0

	for n in array {
		if n == lastNumber {
			currentCount += 1
		} else if currentCount == 2 {
			return true
		} else {
			lastNumber = n
			currentCount = 1
		}
	}

	return currentCount == 2
}

//let test = Helper.digitArray(from: 111122)

let predicates = [alwaysIncreasing, hasANumberInSomeGroupOfOnlyTwo]

let countSatisfy = range.count(where: { i in predicates.allSatisfy { $0(i) } })
print(countSatisfy)
//: [Next](@next)
