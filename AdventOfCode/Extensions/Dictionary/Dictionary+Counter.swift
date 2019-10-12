//
//  Dictionary+Counter.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/3/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public typealias Counter<Element: Hashable> = Dictionary<Element, Int>

public extension Dictionary where Value == Int {
    mutating func record(item: Key) {
        self[item, default: 0] += 1
    }

    mutating func record<Items: Collection>(collection: Items) where Items.Element == Key {
        collection.forEach { record(item: $0) }
    }

    func occurences(of item: Key) -> Int {
        return self[item, default: 0]
    }
}
