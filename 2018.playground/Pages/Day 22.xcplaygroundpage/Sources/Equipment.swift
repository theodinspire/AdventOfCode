import Foundation

public enum Equipment {
    case Torch
    case ClimbingGear
    case None

    public func allowed(in terrain: Terrain) -> Bool {
        switch (self, terrain) {
        case (.Torch, .Wet), (.ClimbingGear, .Narrow), (.None, .Rocky):
            return false
        default:
            return true
        }
    }

    public func otherAvailable(in terrain: Terrain) -> Equipment {
        switch (self, terrain) {
        case (.Torch, .Rocky), (.None, .Wet):
            return .ClimbingGear
        case (.ClimbingGear, .Rocky), (.None, .Narrow):
            return .Torch
        case (.Torch, .Narrow), (.ClimbingGear, .Wet):
            return .None
        default:
            return self
        }
    }
}
