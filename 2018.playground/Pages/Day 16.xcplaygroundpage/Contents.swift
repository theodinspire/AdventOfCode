import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "16", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
""".components(separatedBy: .newlines)

let registerRegex = Regex("(Before|After):\\s\\s?\\[(\\d+), (\\d+), (\\d+), (\\d+)\\]")

func parseRegister(from line: String) -> [Int]? {
    guard let captures = registerRegex.firstMatch(in: line)?.captures.compacted().compactMap(Int.init),
        captures.count == 4 else { return nil }

    return captures
}

func parseInstructionSet(from line: String) -> [Int]? {
    let captures = line.components(separatedBy: .whitespaces).compactMap(Int.init)

    guard captures.count == 4 else { return nil }

    return captures
}

func perform(operation: Instruction.Code, with inputs: [Int], on register: [Int]) -> [Int] {
    guard inputs.count == 3, register.count == 4
        else { return Array(repeating: 0, count: 4) }

    let a = inputs[0]
    let b = inputs[1]
    let c = inputs[2]
    var output = register

    switch operation {
    // Addition
    case .addr:
        output[c] = register[a] + register[b]
    case .addi:
        output[c] = register[a] + b

    // Multiplication
    case .mulr:
        output[c] = register[a] * register[b]
    case .muli:
        output[c] = register[a] * b

    // Bitwise AND
    case .banr:
        output[c] = register[a] & register[b]
    case .bani:
        output[c] = register[a] & b

    // Bitwise OR
    case .borr:
        output[c] = register[a] | register[b]
    case .bori:
        output[c] = register[a] | b

    // Assignment
    case .setr:
        output[c] = register[a]
    case .seti:
        output[c] = a

    // Greater Than
    case .gtir:
        output[c] = a           >  register[b] ? 1 : 0
    case .gtri:
        output[c] = register[a] >  b           ? 1 : 0
    case .gtrr:
        output[c] = register[a] >  register[b] ? 1 : 0

    // Equality
    case .eqir:
        output[c] = a           == register[b] ? 1 : 0
    case .eqri:
        output[c] = register[a] == b           ? 1 : 0
    case .eqrr:
        output[c] = register[a] == register[b] ? 1 : 0
    }

    return output
}

let allInstructions = Set([Instruction.Code.addr, .addi, .mulr, .muli,
                                          .banr, .bani, .borr, .bori,
                                          .setr, .seti, .gtir, .gtri,
                                          .gtrr, .eqir, .eqri, .eqrr])

//guard let before = parseRegister(from: sample[0]),
//    let instructionSet = parseInstructionSet(from: sample[1]),
//    let after = parseRegister(from: sample[2])
//        else { fatalError("Could not parse input") }
//
//let inputs = Array(instructionSet[1...])
//
//let matchingInstructions =
//    allInstructions.filter { after == perform(operation: $0, with: inputs, on: before) }

// Part 1
var observed = [(before: [Int], inputs: [Int], after: [Int])]()

while stream.hasNext {
    guard let before = parseRegister(from: stream.nextLine() ?? ""),
        let inputs = parseInstructionSet(from: stream.nextLine() ?? ""),
        let after = parseRegister(from: stream.nextLine() ?? ""),
        let _ = stream.nextLine()
        else { break }

    observed.append((before, inputs, after))
}

//let counts = observed.filter { item -> Bool in
//    return allInstructions.filter { item.after == perform(operation: $0, with: Array(item.inputs[1...]), on: item.before) }.count >= 3
//}.count
//print(counts)

// Part 2
let instructionRange = 0..<16

var candidates = instructionRange
    .reduce(into: [Int: Set<Instruction.Code>]()) { $0[$1] = allInstructions }

for observation in observed {
    let possibleInstructions = allInstructions.filter { instruction -> Bool in
        return observation.after == perform(operation: instruction, with: Array(observation.inputs[1...]), on: observation.before)
    }

    candidates[observation.inputs[0]]?.formIntersection(possibleInstructions)
}

while !candidates.values.allSatisfy({ $0.count == 1 }) {
    let singulars = candidates.values.filter({ $0.count == 1}).flatMap({ $0 })

    for i in instructionRange {
        guard candidates[i]?.count != 1 else { continue }
        candidates[i]?.subtract(singulars)
    }
}

var instructionMap = candidates.mapValues({ $0.first! })

var register = Array(repeating: 0, count: 4)

while let line = stream.nextLine() {
    guard let instructionSet = parseInstructionSet(from: line),
        instructionSet.count == 4,
        let operation = instructionMap[instructionSet[0]] else { continue }

    register = perform(operation: operation, with: Array(instructionSet[1...]), on: register)
}

print(register)
