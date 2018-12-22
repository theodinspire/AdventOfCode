import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "19", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
""".components(separatedBy: .newlines)

let input =
//    sample
    Array(stream)

// Part 1
let index = Int(input[0].components(separatedBy: .whitespaces)[1]) ?? 0
let instructions = input[1...].compactMap(Instruction.init)

//let register = Register(sized: 6, instructionIndex: index)
//
//register.execute(instructions)
//
//print("Instruction pointer after halting:", register.values[0])

// Part 2
// ???? How to make a general solution?
