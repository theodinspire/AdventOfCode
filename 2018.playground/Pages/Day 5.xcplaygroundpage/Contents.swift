import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "05", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = "dabAcCaCBAcCcaDA"

let input =
//    sample
    stream.nextLine() ?? ""

// Part 1
let minscules = (UInt8(97)...UInt8(122)).map(UnicodeScalar.init)
let majuscules = (UInt8(65)...UInt8(90)).map(UnicodeScalar.init)

let zipper = zip(minscules, majuscules)

// Wrap this in a lambda initializer?
var pattern: Regex? = nil

do {
    pattern = try Regex(string: zipper.map{ "\($0)\($1)|\($1)\($0)" }.joined(separator: "|"))
} catch {
    fatalError(error.localizedDescription)
}

guard let pattern = pattern else { fatalError("How did this not unwrap?") }

func reduce(reactant: String) -> String {
    var reduced = reactant
    while pattern.matches(reduced) {
        reduced.replaceAll(matching: pattern, with: "")
    }

    return reduced
}

print("First pass:", reduce(reactant: input).count)

// Part 2
var minimum = Int.max

for (little, big) in zipper {
    let reduced = reduce(reactant: input.replacingOccurrences(of: String(little), with: "").replacingOccurrences(of: String(big), with: ""))

    minimum = min(minimum, reduced.count)
}

print("Smallest length:", minimum)
