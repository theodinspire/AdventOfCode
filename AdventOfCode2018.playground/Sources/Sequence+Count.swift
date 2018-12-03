import Foundation

public extension Sequence {
    public func count(where predicate: (Element) -> Bool) -> Int {
        return self.reduce(0) { $0 + ( predicate($1) ? 1 : 0 ) }
    }
}
