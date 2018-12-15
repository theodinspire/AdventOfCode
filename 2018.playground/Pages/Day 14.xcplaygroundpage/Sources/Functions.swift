import Foundation

public func generateScores(for target: Int) -> [Int] {
    var scores = [3, 7]
    let range = 10

    var firstElf = 0
    var secondElf = 1

    while scores.count < range + target {
        let firstRecipe = scores[firstElf]
        let secondRecipe = scores[secondElf]

        let newScore = firstRecipe + secondRecipe
        if newScore >= 10 { scores.append(1) }
        scores.append(newScore % 10)

        firstElf = (firstElf + firstRecipe + 1) % scores.count
        secondElf = (secondElf + secondRecipe + 1) % scores.count
    }

    return scores
}
