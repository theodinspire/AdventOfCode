import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "14", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

guard let input = Int(stream.nextLine() ?? "") else { fatalError("Could not read input as an integer") }

// Part 1
let target = input
let range = 10

let scores = generateScores(for: 100_000_000)

print("5158916779", scores[9..<(9 + range)].map(String.init).joined())
print("0124515891", scores[5..<(5 + range)].map(String.init).joined())
print("9251071085", scores[18..<(18 + range)].map(String.init).joined())
print("5941429882", scores[2018..<(2018 + range)].map(String.init).joined())
print(scores[input..<(input + range)].map(String.init).joined())

// Part 2
let allScores = scores.map(String.init).joined()
let targetString = String(target)

let banged = allScores.replacingOccurrences(of: targetString, with: "!")
let index = banged.firstIndex(of: "!")?.encodedOffset

print(index)
banged.contains("!")
