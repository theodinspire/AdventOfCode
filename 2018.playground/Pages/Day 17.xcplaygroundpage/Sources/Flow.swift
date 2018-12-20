import Foundation
import AdventOfCode

public class Flow {
    public weak var hydrology: Hydrology!

    public let location: Point
    public var state: Fill

    public weak var parent: Flow?

    public var down: Flow?
    public var left: Flow?
    public var right: Flow?

    public var leftFlowStopped = false
    public var rightFlowStopped = false

    public init(to location: Point, from parent: Flow? = nil, in hydrology: Hydrology) {
        self.hydrology = hydrology
        self.location = location
        self.parent = parent

        state = parent == nil ? .Spring : .FlowingWater
        hydrology.map[location] = state
    }

    public func seep() {
        guard location.y < hydrology.yMax else { return }

        let beneath = location.south
        switch hydrology.map[beneath, default: .Sand] {
        case .Sand:
            down = Flow(to: beneath, from: self, in: hydrology)
            hydrology.stack.append(down!.seep)
        case .Clay, .StandingWater:
            hydrology.stack.append(spread)
        default:
            break
        }
    }

    public func spread()  {
        let west = location.west
        let east = location.east

        switch hydrology.map[west, default: .Sand] {
        case .Sand:
            left = Flow(to: west, from: self, in: hydrology)
            hydrology.stack.append(left!.seep)
        case .Clay, .FlowingWater, .StandingWater:
            stopLeftwardFlow()
        default: break
        }

        switch hydrology.map[east, default: .Sand] {
        case .Sand:
            right = Flow(to: east, from: self, in: hydrology)
            hydrology.stack.append(right!.seep)
        case .Clay, .FlowingWater, .StandingWater:
            stopRightwardFlow()
        default: break
        }
    }

    public func stopLeftwardFlow() {
        leftFlowStopped = true
        if parent?.location == location.east {
            rightFlowStopped = true

            parent?.stopLeftwardFlow()
        }

        if rightFlowStopped && parent?.location == location.north {
            settle()
            hydrology.stack.append(parent?.spread ?? { })
        }
    }

    public func stopRightwardFlow() {
        rightFlowStopped = true
        if parent?.location == location.west {
            leftFlowStopped = true

            parent?.stopRightwardFlow()
        }

        if leftFlowStopped && parent?.location == location.north {
            settle()
            hydrology.stack.append(parent?.spread ?? { })
        }
    }

    public func settle() {
        guard state != .StandingWater else { return }
        state = .StandingWater
        hydrology.map[location] = state
        left?.settle()
        right?.settle()
    }
}
