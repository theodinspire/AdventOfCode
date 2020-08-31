import Foundation

public enum Helper {
	public static func digitArray(from number: Int, ofLength length: Int = 6) -> [Int] {
		guard number > 0 else { return [] }

		var array = Array(repeating: 0, count: length)
		var tmp = number

		for i in (0..<length).reversed() {
			array[i] = tmp % 10
			tmp /= 10
		}

		return array
	}
}
