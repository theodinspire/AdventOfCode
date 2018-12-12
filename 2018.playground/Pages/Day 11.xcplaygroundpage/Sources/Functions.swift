import Foundation

public func powerGrid(forSerialNumber serialNumber: Int, withDimensions dimensions: Int) -> [[Int]] {
    var grid = Array(repeating: Array(repeating: 0, count: dimensions), count: dimensions)

    for x in 1...dimensions {
        for y in 1...dimensions {
            let rackId = x + 10
            let powerLevel = ((((rackId * y + serialNumber) * rackId) % 1000) / 100) - 5
            grid[x - 1][y - 1] = powerLevel
        }
    }

    return grid
}

public func nByNTotals(of grid: [[Int]], filterSize: Int = 3) -> [[Int]] {
    let filterOffset = filterSize - 1

    var output = Array(repeating: Array(repeating: 0, count: grid[0].count - filterOffset), count: grid.count - filterOffset)

    for x in 0..<(grid.count - filterOffset) {
        for y in 0..<(grid[x].count - filterOffset) {
            output[x][y] = grid[x...(x + filterOffset)].flatMap({ $0[y...(y + filterOffset)]}).reduce(0, +)
        }
    }

    return output
}

public func getLocationOfMaxCell(in grid: [[Int]]) -> (max: Int, x: Int, y: Int) {
    var runningMax = Int.min
    var location = (x: Int.min, y: Int.min)

    for (x, line) in grid.enumerated() {
        for (y, value) in line.enumerated() {
            if value > runningMax {
                runningMax = value
                location = (x: x + 1, y: y + 1)
            }
        }
    }

    return (runningMax, location.x, location.y)
}
