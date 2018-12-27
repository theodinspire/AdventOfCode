import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "23", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
""".components(separatedBy: .newlines)

struct Nanite {
    let location: Point3D
    let signalRadius: Int

    private static let regex = Regex("pos=<(-?\\d+,-?\\d+,-?\\d+)>, r=(\\d+)")

    init?(from string: String) {
        guard let components = Nanite.regex.firstMatch(in: string)?.captures.compacted(),
            components.count == 2,
            let point = Point3D(from: components[0]),
            let radius = Int(components[1]) else { return nil }

        location = point
        signalRadius = radius
    }
}

let input =
//    sample
    stream
        .compactMap(Nanite.init)

// Part 1
guard let maxRadius = input.max(by: { $0.signalRadius < $1.signalRadius }) else {
    fatalError("Array should have any values")
}

print("Max radius:", maxRadius.signalRadius)
print("Count:", input.count)

print("Number within the largest radius:", input.map { ($0.location - maxRadius.location).manhattanMagnitude }.count(where: { $0 <= maxRadius.signalRadius}))

for nanite in input {
    print("pos=<\(nanite.location.x),\(nanite.location.y),\(nanite.location.z)>, r=\(nanite.signalRadius)")
}
