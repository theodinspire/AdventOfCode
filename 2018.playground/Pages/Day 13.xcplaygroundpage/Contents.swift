import Foundation
import AdventOfCode

guard let filepath = Bundle.main.url(forResource: "13", withExtension: "txt"),
    let stream = StreamReader(url: filepath) else { abort() }

//let sample = """
///->-\\
//|   |  /----\\
//| /-+--+-\\  |
//| | |  | v  |
//\\-+-/  \\-+--/
//  \\------/
//""".components(separatedBy: .newlines)

let sample = """
/>-<\\
|   |
| /<+-\\
| | | v
\\>+</ |
  |   ^
  \\<->/
""".components(separatedBy: .newlines)

let useSample = false
let input = useSample ? sample : Array(stream)

class Cart: Hashable {
    private static var nextId = 1

    var position: Point
    var heading: Heading

    var id: Int

    private var turnIndex = 0

    init(at point: Point, heading direction: Heading) {
        heading = direction
        position = point

        id = Cart.nextId
        Cart.nextId += 1
    }

    var next: Point {
        switch heading {
        case .North:
            return position.north
        case .East:
            return position.east
        case .South:
            return position.south
        case .West:
            return position.west
        }
    }

    func moveTo(point: Point) {
        position = point
    }

    func turn(on rail: Character) {
        switch (rail, heading) {
        case ("+", _):
            turnAtIntersection()
        case ("/", .North),
             ("\\", .East),
             ("/", .South),
             ("\\", .West):
            heading = heading.right
        case ("\\", .North),
             ("/", .East),
             ("\\", .South),
             ("/", .West):
            heading = heading.left
        default: break
        }
    }

    private func turnAtIntersection() {
        switch turnIndex % 3 {
        case 0: heading = heading.left
        case 2: heading = heading.right
        default: break
        }

        turnIndex += 1
    }

    static func ==(this: Cart, that: Cart) -> Bool {
        return this.id == that.id
    }

    var hashValue: Int { return id }
}

//func printMap(rails: [Point : Character], andCarts carts: [Cart]) {
//    var map = rails
//
//    let maxX = rails.keys.lazy.map { $0.x }.max() ?? 0
//    let maxY = rails.keys.lazy.map { $0.y }.max() ?? 0
//
//    for cart in carts {
//        let chevron: Character
//
//        switch cart.heading {
//        case .North: chevron = "^"
//        case .East: chevron = ">"
//        case .South: chevron = "v"
//        case .West: chevron = "<"
//        }
//
//        map[cart.position] = chevron
//    }
//
//    for y in 0...maxY {
////        print((0...maxX).map { String(map[Point(x: $0, y: y), default: " "]) }.joined())
//    }
//    print()
//}

var rails = [Point : Character]()
var carts = [Cart]()

lines: for (y, line) in input.lazy.enumerated() {
    points: for (x, item) in line.enumerated() {
        guard item != " " else { continue points }

        let point = Point(x: x, y: y)

        switch item {
        case "^":
            carts.append(Cart(at: point, heading: .North))
            rails[point] = "|"
        case ">":
            carts.append(Cart(at: point, heading: .East))
            rails[point] = "-"
        case "v":
            carts.append(Cart(at: point, heading: .South))
            rails[point] = "|"
        case "<":
            carts.append(Cart(at: point, heading: .West))
            rails[point] = "-"
        default:
            rails[point] = item
        }
    }
}

//printMap(rails: rails, andCarts: carts)

print("Carts remaining:", carts.count)
print(carts.map { $0.id })

var cartsCrashed = Set<Cart>()
var index = 0
let nullPoint = Point(x: Int.max, y: Int.max)
var lastCart = carts[0]

ticks: repeat {
    carts.sort(by: { this, that in
        this.position.y < that.position.y ||
            ( this.position.y == that.position.y && this.position.x < that.position.x ) })

    moving: for cart in carts {
        guard !cartsCrashed.contains(cart) else { continue moving }

        let target = cart.next

        if let crash = carts.first(where: { $0.position == target }) {
            print("Crash at:", target)
            cart.position = nullPoint
            crash.position = nullPoint
            cartsCrashed.insert(cart)
            cartsCrashed.insert(crash)
        } else {
            cart.moveTo(point: target)
            guard let rail = rails[target] else {
                print("No path to follow at", target)
                break ticks
            }
            cart.turn(on: rail)
            lastCart = cart
        }
    }
} while carts.count > cartsCrashed.count + 1

print("Carts crashed:", cartsCrashed.count)
print("Last cart resting point:", lastCart.position)

print(lastCart.next)
