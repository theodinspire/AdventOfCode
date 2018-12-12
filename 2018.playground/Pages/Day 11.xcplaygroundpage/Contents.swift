import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "11", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let input = Int(stream.nextLine() ?? "") ?? 1

// Part 1

//print(powerGrid(forSerialNumber: 8)[3 - 1][5 - 1])

let targetGrid = powerGrid(forSerialNumber: input, withDimensions: 300)

let targetGridTotals = nByNTotals(of: targetGrid)

print(getLocationOfMaxCell(in: targetGridTotals))

var runningMax = (max: Int.min, x: Int.min, y: Int.min)
var maxFilterSize = 0

for i in 1...300 {
    let filtered = nByNTotals(of: targetGrid, filterSize: i)
    let local = getLocationOfMaxCell(in: filtered)

    if local.max > runningMax.max {
        runningMax = local
        maxFilterSize = i
    }
}

print(runningMax, maxFilterSize)


