import Foundation

guard let filepath = Bundle.main.url(forResource: "01", withExtension: "txt"),
    let input = StreamReader(url: filepath) else { abort() }

let sample = [1, -2, 3, 1, 1, -2, 3, 1]

// Part 1
print("Part 1")
print(input.compactMap(Int.init).reduce(0, +))

// Part 2
print("\nPart 2")

var set = Set<Int>()
var current = 0

repeat {
    if input.atEndOfFile { input.rewind() }
    guard let line = input.nextLine(), let n = Int(line) else { continue }

    set.insert(current)
    current += n
} while !set.contains(current)

print(current)
