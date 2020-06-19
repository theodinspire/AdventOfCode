//: [Previous](@previous)

import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "2", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

guard let line = stream.nextLine() else { fatalError("Check input contents") }

let input = line.components(separatedBy: .punctuationCharacters).compactMap(Int.init)

// First part
func runProgram(noun: Int, verb: Int, program: [Int]) -> Int {
    var program = program

    program[1] = noun
    program[2] = verb

    var position = 0

    repeat {
        guard position < program.count + 3 else {
            print("Index \(position) out of program bounds")
            break
        }

        let instruction = program[position]

        guard instruction != 99 else { break }

        let a = program[position + 1]
        let b = program[position + 2]
        let c = program[position + 3]

        guard a < program.count else {
            print("Index 'a' \(a) out of program bounds")
            break
        }
        guard b < program.count else {
            print("Index 'b' (\(b)) out of program bounds")
            break
        }
        guard c < program.count else {
            print("Index 'c' \(c) out of program bounds")
            break
        }

        if instruction == 1 {
            program[c] = program[a] + program[b]
        } else if instruction == 2 {
            program[c] = program[a] * program[b]
        }

        position += 4
    } while true

    return program[0]
}

print("Inputs being 12 and 2", runProgram(noun: 12, verb: 2, program: input))

//Part 2
let constant = runProgram(noun: 0, verb: 0, program: input)
print("Contant:", constant)

let nounCoefficient = runProgram(noun: 1, verb: 0, program: input) - constant
print("Noun coefficient:", nounCoefficient)

let verbCoefficient = runProgram(noun: 0, verb: 1, program: input) - constant
print("Verb coefficient:", verbCoefficient)

//: [Next](@next)
