import Foundation
import AdventOfCode

import Regex

guard let filepath = Bundle.main.url(forResource: "09", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = """
9 players; last marble is worth 25 points: high score is 32
10 players; last marble is worth 1618 points: high score is 8317
13 players; last marble is worth 7999 points: high score is 146373
17 players; last marble is worth 1104 points: high score is 2764
21 players; last marble is worth 6111 points: high score is 54718
30 players; last marble is worth 5807 points: high score is 37305
"""

guard let input = stream.nextLine() else { fatalError("No input") }

let regex = Regex("(\\d+) players; last marble is worth (\\d+) points(: high score is (\\d+))?")

let scoringTurn = 23
let backstep = 7

// Day 1
let sampleGames = regex.allMatches(in: sample).map { game in game.captures.compacted().compactMap(Int.init)}

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
            print(otherMarble, score, turn)

            playerScores[(turn - 1) % players] += score
        } else {
            currentMarbleIndex = (currentMarbleIndex + 2).modulo(circle.count)
            circle.insert(turn, at: currentMarbleIndex)
        }
    }

//    print(circle)

    return playerScores
}

//for game in sampleGames {
//    let players = game[0]
//    let marbles = game[1]
//
//    print("Expected:", game[2],
//          "Actual:", playGame(for: players, with: marbles).max() ?? 0)
//}

let myGame = regex.firstMatch(in: input)?.captures.compacted().compactMap(Int.init) ?? []

//print(playGame(for: myGame[0], with: myGame[1]).max() ?? 0)

// Part 2
func currentIndex(after turn: Int) -> Int {
    let previousScoringRounds = turn / scoringTurn
    let circleLength = turn - previousScoringRounds
    let offset = previousScoringRounds * backstep

    let index = (2 * (circleLength - circleLength.mostSignificantBit) + 1 - offset).modulo(circleLength + 1)

    return index
}

//print((0...65).map(currentIndex))
//print(playGame(for: 10, with: 230))

let marble = 9

var index = currentIndex(after: marble)
print(index)

loop: for turn in (marble + 1)...25 {
    let other = currentIndex(after: turn)

    guard turn % scoringTurn != 0 else {
        if other == index {
            index = -1
            break loop
        } else if other < index {
            index -= 1
        }

        continue loop
    }

    if other <= index { index += 1 }
    print("Player:", (turn - 1) % 9 + 1,
          "Index:", index)
}

print("Final index:", index)
