import Foundation
import AdventOfCode

//print("Hello World")

guard let filepath = Bundle.main.url(forResource: "1", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let input = stream.compactMap(Int.init);

// Part 1
//let example = [12, 14, 1969, 100756]
//let answers = [2, 2, 654, 33583]

let cost: (Int) -> Int = { max(($0 / 3) - 2, 0) }

//print(zip(example.map(cost), answers).map({ $0.0 == $0.1 }).reduce(true, { $0 == $1 }))

print(input.map(cost).sum())

// Part 2
//let example = [1969, 100756]

func totalCost(_ weight: Int) -> Int {
    var total = 0
    var additional = cost(weight)

    while additional > 0 {
        total += additional
        additional = cost(additional)
    }

    return total
}

//print(example.map(totalCost))

print(input.map(totalCost).sum())

//: [Next](@next)
