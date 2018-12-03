import Foundation

guard let filepath = Bundle.main.url(forResource: "03", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

struct Claim {
    let id: Int

    let left: Int
    let top: Int

    let width: Int
    let height: Int

    var cutVertical: Range<Int> {
        get { return top..<(top + height) }
    }
    var cutHorizontal: Range<Int> {
        get { return left..<(left  + width)}
    }

    init?(from claimSlip: String) {
        let parts = claimSlip.split(separator: " ")
        guard parts.count == 4, parts[1] == "@" else { return nil }

        let idPart = parts[0]
        guard idPart.first == "#", let id = Int(idPart[1...]) else { return nil }
        self.id = id

        let corner = parts[2].components(separatedBy: .init(charactersIn: ",:"))
        guard corner.count >= 2, let left = Int(corner[0]), let top = Int(corner[1]) else { return nil }

        self.left = left
        self.top = top

        let dimensions = parts[3].components(separatedBy: "x")
        guard dimensions.count == 2, let width = Int(dimensions[0]), let height = Int(dimensions[1]) else { return nil }

        self.width = width
        self.height = height
    }
}

let sample = [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
    ]

let input =
//    sample.compactMap(Claim.init)
    stream.compactMap(Claim.init)

// Part 1

var cloth = [Int: [Int: Set<Int>]]()

for claim in input {
    for x in claim.cutHorizontal {
        for y in claim.cutVertical {
            cloth[x, default: [:]][y, default: []].insert(claim.id)
        }
    }
}

let overlaps = cloth.values.flatMap({ $0.values }).filter { $0.count > 1}

print("Overlapping squares:", overlaps.count)

// Part 2
let allIds = Set(input.map { $0.id })

let overlappingClaims = Set(overlaps.flatMap { $0 })

let candidates = allIds.subtracting(overlappingClaims)

if candidates.count == 1, let target = candidates.first {
    print("Correct claim:", target)
} else {
    print("Something's wrong:", candidates)
}
