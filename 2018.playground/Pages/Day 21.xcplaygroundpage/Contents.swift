import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "21", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

// Part 1
let input = Array(stream)

let index = Int(input[0].components(separatedBy: .whitespaces)[1]) ?? 0
let instructions = input[1...].compactMap(Instruction.init)

let register = Register(sized: 6, instructionIndex: index)

let zeroEquallingInstruction = 28 // Hand counted
let zeroComparingIndex = 3

//while register.instructionPointer < instructions.count {
//    guard register.instructionPointer != zeroEquallingInstruction else {
//        print("Value of register being compared to zero:", register.values[zeroComparingIndex])
//        break
//    }
//
//    register.perform(instructions[register.instructionPointer])
//}

// Part 2
//let one = 300
//var four = 0
//
//while (four + 1) * 256 <= one {
//    four += 1
//}
//
//print(four == one / 256)

var values = Array(repeating: 0, count: 6)
var exitCandidates = [Int]()

repeat {
    values[1] = values[3] | 65536
    values[3] = 4921097

    repeat {
        values[3] += (values[1] & 0xff)
        values[3] &= 0xffffff
        values[3] *= 65899
        values[3] &= 0xffffff

        guard values[1] >= 256 else { break }

        values[1] /= 256
    } while true

    guard !exitCandidates.contains(values[3]) else { break }
    exitCandidates.append(values[3])
} while values[0] != values[3]
//} while false

//print(exitCandidates)
print(exitCandidates.contains(4797782))
print(exitCandidates)
