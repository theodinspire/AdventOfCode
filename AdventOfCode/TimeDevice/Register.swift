import Foundation

public class Register {
    public var values: [Int]

    public let size: Int
    private let instructionIndex: Int

    private(set) public var instructionPointer: Int {
        get {
            return values[instructionIndex]
        }

        set {
            values[instructionIndex] = newValue
        }
    }

    public init(sized size: Int, instructionIndex: Int) {
        values = Array(repeating: 0, count: size)
        self.size = size
        self.instructionIndex = instructionIndex
    }

    public func perform(_ instruction: Instruction) {
        switch instruction.code {
        // Addition
        case .addr:
            values[instruction.c] = values[instruction.a] &+ values[instruction.b]
        case .addi:
            values[instruction.c] = values[instruction.a] &+ instruction.b

        // Multiplication
        case .mulr:
            values[instruction.c] = values[instruction.a] &* values[instruction.b]
        case .muli:
            values[instruction.c] = values[instruction.a] &* instruction.b

        // Bitwise AND
        case .banr:
            values[instruction.c] = values[instruction.a] & values[instruction.b]
        case .bani:
            values[instruction.c] = values[instruction.a] & instruction.b

        // Bitwise OR
        case .borr:
            values[instruction.c] = values[instruction.a] | values[instruction.b]
        case .bori:
            values[instruction.c] = values[instruction.a] | instruction.b

        // Assignment
        case .setr:
            values[instruction.c] = values[instruction.a]
        case .seti:
            values[instruction.c] = instruction.a

        // Greater Than
        case .gtir:
            values[instruction.c] = instruction.a           >  values[instruction.b]
                ? 1 : 0
        case .gtri:
            values[instruction.c] = values[instruction.a] >  instruction.b
                ? 1 : 0
        case .gtrr:
            values[instruction.c] = values[instruction.a] >  values[instruction.b]
                ? 1 : 0

        // Equality
        case .eqir:
            values[instruction.c] = instruction.a         == values[instruction.b]
                ? 1 : 0
        case .eqri:
            values[instruction.c] = values[instruction.a] == instruction.b
                ? 1 : 0
        case .eqrr:
            values[instruction.c] = values[instruction.a] == values[instruction.b]
                ? 1 : 0
        }

        instructionPointer += 1
    }

    public func execute(_ instructions: [Instruction]) {
        let range = 0..<instructions.count
        var iteration = 1

//        print(values)
//        for _ in range {
        while range.contains(instructionPointer) {
            let instruction = instructions[instructionPointer]
//            let current = instructionPointer
            perform(instruction)
//            print("\(current):", instruction, values)

            if iteration % 100_000_000 == 0 { print("Iteration", iteration, "complete") }
            iteration += 1
        }
    }

    public func set(at index: Int, to value: Int) {
        guard index < values.count, index >= 0 else { return }

        values[index] = value
    }
}
