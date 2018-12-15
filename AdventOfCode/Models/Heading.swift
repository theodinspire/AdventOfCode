//
//  Direction.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/13/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public enum Heading {
    case North
    case East
    case South
    case West

    public var left: Heading {
        switch self {
        case .North: return .West
        case .East: return .North
        case .South: return .East
        case .West: return .South
        }
    }

    public var right: Heading {
        switch self {
        case .North: return .East
        case .East: return .South
        case .South: return .West
        case .West: return .North
        }
    }

    public var straight: Heading { return self }

    public var behind: Heading {
        switch self {
        case .North: return .South
        case .East: return .West
        case .South: return .North
        case .West: return .East
        }
    }
}
