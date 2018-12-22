import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "20", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { fatalError("Check input filepath") }

// Part 1

//let short = "^WNE$"
//let shortCastle = Castle(from: short)
//shortCastle.printFloorPlan()
//print("Longest length of path in castle:", shortCastle.longestPath(), "\n")
//
//let middle = "^ENWWW(NEEE|SSE(EE|N))$"
//let middleCastle = Castle(from: middle)
//middleCastle.printFloorPlan()
//print("Longest length of path in castle:", middleCastle.longestPath(), "\n")
//
//let long = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
//let longCastle = Castle.init(from: long)
//longCastle.printFloorPlan()
//print("Longest length of path in castle:", longCastle.longestPath(), "\n")
//
//let twentyThree = Castle(from: "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$")
//print("This should be twenty-three:", twentyThree.longestPath())
//
//let thirtyOne = Castle(from: "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$")
//thirtyOne.printFloorPlan()
//print("And ths thirty-one", thirtyOne.longestPath())

guard let input = stream.nextLine() else { fatalError("Could not read input") }

let castle = Castle(from: input)
//castle.printFloorPlan()
let depths = castle.getDepths()
print("Longest path in the castle:", depths.values.max() ?? 0)

print("Number of rooms at least 1000 away:", depths.count(where: { $0.value >= 1000 }))
