import Foundation
import AdventOfCode

public enum Pot: Character {
    case Plant = "#"
    case Empty = "."

    public static let numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter
    }()

    public static func growth(
        of initialState: [Int : Pot],
        accordingTo notes: [String : Pot],
        after generations: Int)
            -> [Int : Pot] {
        var currentState = initialState

        let total = Pot.numberFormatter.string(from: NSNumber(value: generations)) ?? "Error"

        for generation in 0..<generations {
            currentState = currentState.filter { $0.value == .Plant }

            guard let left = currentState.keys.min(),
                let right = currentState.keys.max() else {
                    break
            }

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

        return currentState
    }

    public static func pattern(of pots: [Int : Pot]) -> String {
        let state = pots.filter { $0.value == .Plant }

        guard let left = state.keys.min(), let right = state.keys.max() else {
            return ""
        }

        return String(state[left...right, default: .Empty].map { $0.rawValue })
    }
}

public extension String {
    public init<Pots>(_ pots: Pots) where Pots: Sequence, Pots.Element == Pot {
        self.init(pots.map { $0.rawValue })
    }
}
