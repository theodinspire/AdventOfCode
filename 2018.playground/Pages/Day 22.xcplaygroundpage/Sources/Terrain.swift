import Foundation

public enum Terrain: Int {
    case Rocky = 0
    case Wet = 1
    case Narrow = 2

    public init(from int: Int) {
        guard int.signum() != -1 else { fatalError("Unexpected input") }
        self.init(rawValue: int % 3)!
    }
}
