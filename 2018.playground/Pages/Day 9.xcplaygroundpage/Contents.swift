import Foundation
import AdventOfCode

//import Regex
//
//guard let filepath = Bundle.main.url(forResource: "09", withExtension: "txt"),
//    let stream = StreamReader(url: filepath) else { abort() }
//
//let sample = """
//9 players; last marble is worth 25 points: high score is 32
//10 players; last marble is worth 1618 points: high score is 8317
//13 players; last marble is worth 7999 points: high score is 146373
//17 players; last marble is worth 1104 points: high score is 2764
//21 players; last marble is worth 6111 points: high score is 54718
//30 players; last marble is worth 5807 points: high score is 37305
//"""
//
//guard let input = stream.nextLine() else { fatalError("No input") }
//
//let regex = Regex("(\\d+) players; last marble is worth (\\d+) points(: high score is (\\d+))?")
//
//let scoringTurn = 23
//let backstep = 7

// Day 1
//let sampleGames = regex.allMatches(in: sample).map { game in game.captures.compacted().compactMap(Int.init)}

func playGame(for players: Int, with marbles: Int) -> [Int] {
    var circle = [0]
    circle.reserveCapacity(marbles)
    var currentMarbleIndex = 0

    var playerScores = Array(repeating: 0, count: players)

    for turn in 1...marbles {
        if turn % 23 == 0 {
            currentMarbleIndex = (currentMarbleIndex - 7).modulo(circle.count)
            let otherMarble = circle.remove(at: currentMarbleIndex) ?? 0

            let score = turn + otherMarble

            playerScores[(turn - 1) % players] += score
        } else {
            currentMarbleIndex = (currentMarbleIndex + 2).modulo(circle.count)
            circle.insert(turn, at: currentMarbleIndex)
        }
    }

    return playerScores
}

//for game in sampleGames {
//    let players = game[0]
//    let marbles = game[1]
//
//    print("Expected:", game[2],
//          "Actual:", playGame(for: players, with: marbles).max() ?? 0)
//}

//let myGame = regex.firstMatch(in: input)?.captures.compacted().compactMap(Int.init) ?? []

print(playGame(for: 464, with: 7173000).max())

// Part 2
//func currentIndex(after turn: Int) -> Int {
//    let previousScoringRounds = turn / scoringTurn
//    let circleLength = turn - (previousScoringRounds)
//    let offset = previousScoringRounds * backstep
//
//    let index = (2 * (circleLength - (circleLength - offset).mostSignificantBit) + 1 - offset).modulo(circleLength + 1)
//
//    return index
//}
//
//func getValue(of marble: Int, onTurn turn: Int) -> Int {
//    var index = marble
//
//    loop: for turn in (0...turn).reversed() {
//        let other = currentIndex(after: turn)
//
//        if turn % scoringTurn == 0, other <= index {
//            index += 1
//            continue loop
//        }
//        if other == index {
//            return turn
//        } else if other <= index {
//            index -= 1
//        }
//    }
//
//    return 0
//}
//
//func play(ofPlayers players: Int, with marbles: Int) -> [Int] {
//    var scores = Array(repeating: 0, count: players)
//
//    for round in (1...(marbles / scoringTurn)) {
//        let turn = round * scoringTurn
//        let index = currentIndex(after: turn)
//        let value = getValue(of: index, onTurn: turn - 1)
//
//        scores[turn % players] += value + turn
//    }
//
//    return scores
//}
//
////for round in 23..<45 {
////    print(round, (0..<(round - 1)).map { getValue(of: $0, onTurn: round) })
////}
