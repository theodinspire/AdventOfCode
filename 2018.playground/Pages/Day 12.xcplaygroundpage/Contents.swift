import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "12", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = """
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
""".components(separatedBy: .newlines)

let useSample = false
let input = useSample ? sample : Array(stream)

let initialState = input[0]
    .replacingOccurrences(of: "initial state: ", with: "")
    .enumerated()
    .reduce(into: [Int : Pot]())
    { (dictionary, pair) in dictionary[pair.offset] = Pot(rawValue: pair.element) }

let notes = input[2...]
    .lazy.map { $0.components(separatedBy: " => ") }.lazy
    .reduce(into: [String : Pot]()) { $0[$1[0]] = Pot(rawValue: Character($1[1])) }


print("Initial growth")
var state = Pot.growth(of: initialState, accordingTo: notes, after: 20)
print(state.filter { $0.value == .Plant }.reduce(0, { $0 + $1.key}))

// Part 2
//print("\nThe long haul")
//let finalState = Pot.growth(of: initialState,
//                            accordingTo: notes,
//                            after: 50_000_000_000)
//
//print(finalState.filter { $0.value == .Plant }.reduce(0, { $0 + $1.key}))
//

var previousStates = [String : (generation: Int, left: Int)]()
let generations = 50_000_000_000

var currentState = initialState

let total = Pot.numberFormatter.string(from: NSNumber(value: generations)) ?? "Error"

var repetition = (start: 0, cycle: 0, offset: 0)

for generation in 0..<generations {
    currentState = currentState.filter { $0.value == .Plant }
    let pattern = Pot.pattern(of: currentState)

    guard let left = currentState.keys.min(),
        let right = currentState.keys.max() else {
            break
    }

    guard !previousStates.keys.contains(pattern) else {
        let previous = previousStates[pattern] ?? (Int.min, Int.min)
        repetition = (previous.generation, generation - previous.generation, left - previous.left)
        print("Previous:", previous,
              "Current:", (generation: generation, left: left))
        break
    }

    previousStates[pattern] = (generation, left)

    var nextState = [Int : Pot]()

    for i in (left - 2)...(right + 2) {
        nextState[i] = notes[String(currentState[(i-2)...(i+2), default: .Empty])] ?? .Empty
    }

    currentState = nextState
    if generation % 10_000 == 0 {
        let current = Pot.numberFormatter.string(from: NSNumber(value: generation)) ?? "Error"
        let message = "Generation \(current) of \(total) complete."
        print("\(message)")
    }
}

print(Pot.pattern(of: currentState))
let cyclesToSkip = (generations - repetition.start) / repetition.cycle - 1
let timeToSkip = cyclesToSkip * repetition.cycle

let newPots = currentState.keys.map { $0 + cyclesToSkip * repetition.offset }

let generationsToCover = generations - (timeToSkip + repetition.start)

let value = newPots.reduce(0, +)
print(value)
