import Foundation

guard let filepath = Bundle.main.url(forResource: "02", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }
let sample = [
    "abcde",
    "fghij",
    "klmno",
    "pqrst",
    "fguij",
    "axcye",
    "wvxyz"
]

let input = stream.filter { $0.count > 0 }

// Part 1
let counters = input.map { line in line.reduce(into: [:]) { $0[$1, default: 0] += 1 } }

let twos = counters.count(where: { $0.values.contains(2) })
let threes = counters.count(where: { $0.values.contains(3) })

print(twos * threes)

// Part 2
outer: for (i, this) in input.enumerated() {
    inner: for that in input[(i + 1)...] {
        let zipper = zip(this, that).lazy

        guard (zipper.count(where: { $0 != $1 })) == 1 else { continue inner }

        print("Box Ids:", this, that)
        print("Common letters:", String(zipper.filter { $0 == $1 }.map { $0.0 }))

        break outer
    }
}
