import Foundation
import AdventOfCode

public typealias Leg = (heading: Heading, steps: Int)

public enum Day3Helper {
	public static func heading(from direction: Character) -> Heading {
		switch direction {
		case "U":
			return .North
		case "R":
			return .East
		case "D":
			return .South
		case "L":
			return .West
		default:
			fatalError("Character \(direction) does not correspond to a heading")
		}
	}

	public static func intoLeg(from string: String) -> Leg {
		return (heading(from: string.first!), Int(string.suffix(string.count - 1))!)
	}

	public static func points(from legs: [Leg]) -> [Point] {
		var points = [Point]()
		var lastPoint = Point.origin

		for leg in legs {
			for _ in 1...leg.steps {
				lastPoint = lastPoint.neighbor(toThe: leg.heading)
				points.append(lastPoint)
			}
		}

		return points
	}

	public static func intersectionDistances(for path: [Point], at intersections: Set<Point>) -> [Point: Int] {
		let items = path.enumerated().filter({ intersections.contains($0.element) })
		var dictionary = [Point: Int]()

		for item in items { dictionary[item.element] = item.offset }

		return dictionary.mapValues({ $0 + 1 }) // Origin not included on path
	}
}

public extension String {
	func intoPaths() -> [[Point]] {
		return components(separatedBy: "\n")
			.filter({ !$0.isEmpty })
			.map { $0.components(separatedBy: .punctuationCharacters).map(Day3Helper.intoLeg) }
			.map(Day3Helper.points)
	}
}
