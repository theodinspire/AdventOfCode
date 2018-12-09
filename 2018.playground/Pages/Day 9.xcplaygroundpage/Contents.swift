import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "09", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = ["Strings?"]
