import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "24", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

let sample = """
Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
""".components(separatedBy: .newlines)

class Group {
    var units: Int

    let hitPoints: Int
    let attack: Int
    let initiative: Int
    let power: String

    let weaknesses: Set<String>
    let immunities: Set<String>

    static let unitsRegex = Regex("(\\d+) units")
    static let hitPointsRegex = Regex("each with (\\d+) hit points")
    static let attackRegex = Regex("with an attack that does (\\d+) (\\w+) damage")
    static let initiativeRegex = Regex("at initiative (\\d+)")
    static let immunityRegex = Regex("immune to ([\\w,\\s]+)[;\\)]")
    static let weaknessRegex = Regex("weak to ([\\w,\\s]+)[;\\)]")

    static func parseUnits(from input: String) -> Int? {
        guard let unitCount = unitsRegex.firstMatch(in: input)?.captures.compacted().compactMap(Int.init).first
            else { return nil }

        return unitCount
    }

    static func parseHitPoints(from input: String) -> Int? {
        guard let hitPoints = hitPointsRegex.firstMatch(in: input)?.captures.compacted().compactMap(Int.init).first
            else { return nil }

        return hitPoints
    }

    static func parseAttack(from input: String) -> (attack: Int, power: String)? {
        guard let components = attackRegex.firstMatch(in: input)?.captures.compacted(),
            components.count == 2,
            let attack = Int(components[0]) else { return nil }

        return (attack, components[1])
    }

    static func parseInitiative(from input: String) -> Int? {
        guard let initiative = initiativeRegex.firstMatch(in: input)?.captures.compacted().compactMap(Int.init).first
            else { return nil }

        return initiative
    }

    static func parseImmunities(from input: String) -> Set<String> {
        guard let immunities = immunityRegex.firstMatch(in: input)?
            .captures.compacted().flatMap({ $0.components(separatedBy: ", ")})
            else { return [] }

        return Set(immunities)
    }

    static func parseWeaknesses(from input: String) -> Set<String> {
        guard let weaknesses = weaknessRegex.firstMatch(in: input)?
            .captures.compacted().flatMap({ $0.components(separatedBy: ", ")})
            else { return [] }

        return Set(weaknesses)
    }

    init?(from input: String) {
        guard let units = Group.parseUnits(from: input),
            let hitPoints = Group.parseHitPoints(from: input),
            let combat = Group.parseAttack(from: input),
            let initiative = Group.parseInitiative(from: input)
            else { return nil }

        self.units = units
        self.hitPoints = hitPoints
        self.attack = combat.attack
        self.power = combat.power
        self.initiative = initiative
        self.immunities = Group.parseImmunities(from: input)
        self.weaknesses = Group.parseWeaknesses(from: input)
    }
}

