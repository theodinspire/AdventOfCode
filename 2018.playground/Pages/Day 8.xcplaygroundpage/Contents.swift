import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "08", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = ["2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"]

let isSample =
//    true
    false

let input = (isSample ? AnySequence(sample) : AnySequence(stream))
    .first(where: { _ in true })?
    .components(separatedBy: .whitespaces)
    .compactMap(Int.init) ?? []

class LicenseNode {
    let children: [LicenseNode]
    let metadata: [Int]

    var sumOfMetadata: Int {
        return metadata.reduce(0, +)
            + children.map { $0.sumOfMetadata }.reduce(0, +)
    }

    var value: Int {
        guard !children.isEmpty else { return sumOfMetadata }

        var value = 0

        for index in metadata.map({ $0 - 1 }) {
            guard index < children.count else { continue }
            value += children[index].value
        }

        return value
    }

    convenience init(from list: [Int]) {
        var iterator = list.makeIterator()
        self.init(using: &iterator)
    }

    init(using iterator: inout IndexingIterator<[Int]>) {
        var kids = [LicenseNode]()
        var data = [Int]()

        guard let childCount = iterator.next(), let metadataCount = iterator.next() else {
            children = []
            metadata = []
            return
        }

        for _ in 0..<childCount {
            kids.append(LicenseNode(using: &iterator))
        }

        for _ in 0..<metadataCount {
            guard let item = iterator.next() else { break }
            data.append(item)
        }

        children = kids
        metadata = data
    }
}

let license = LicenseNode(from: input)

// Part 1
print("Sum of all metadata:", license.sumOfMetadata)

// Part 2
print("License value:", license.value)
