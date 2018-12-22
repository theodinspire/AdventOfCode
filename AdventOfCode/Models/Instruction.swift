import Foundation

import Regex

public struct Instruction {
    public let code: Code
    public let a: Int
    public let b: Int
    public let c: Int

    private static let regex = Regex("(\\w{4}) (\\d+) (\\d+) (\\d+)")

    public init?(from string: String) {
        guard let captures = Instruction.regex
            .firstMatch(in: string)?.captures.compacted(),
            let code = Code(rawValue: captures[0]) else { return nil }

        self.code = code

        let values = captures[1...].compactMap(Int.init)

        guard values.count == 3 else { return nil }

        a = values[0]
        b = values[1]
        c = values[2]
    }

    public enum Code: String {
        // Addition
        case addr
        case addi

        // Multiplication
        case mulr
        case muli

        // Bitwise AND
        case banr
        case bani

        // Bitwise OR
        case borr
        case bori

        // Assignment
        case setr
        case seti

        // Greater Than
        case gtir
        case gtri
        case gtrr

        // Equality
        case eqir
        case eqri
        case eqrr
    }
}

extension Instruction: CustomStringConvertible {
    public var description: String { return "\(code.rawValue) \(a) \(b) \(c)" }
}
