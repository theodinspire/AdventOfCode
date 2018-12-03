import Foundation

guard let filepath = Bundle.main.url(forResource: "03", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

let sample = ["Strings?"]
