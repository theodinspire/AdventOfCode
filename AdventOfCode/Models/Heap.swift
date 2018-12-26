//
//  Heap.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/25/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public struct Heap<Element> {
    private(set) public var elements: [Element]
    private let sort: (_ preceding: Element, _ following: Element) -> Bool

    public init(using sort: @escaping (Element, Element) -> Bool) {
        elements = []
        self.sort = sort
    }

    public init<Source>(from source: Source, using sort: @escaping (Element, Element) -> Bool) where Source: Sequence, Source.Element == Element {
        self.init(using: sort)
        for element in source { self.add(element) }
    }

    // Heap methods
    public func peek() -> Element? {
        guard elements.count > 0 else { return nil }
        return elements[0]
    }

    mutating public func poll() -> Element? {
        guard let element = peek() else { return nil }

        guard elements.count > 1 else {
            elements = []
            return element
        }

        elements[0] = elements.removeLast()
        bubbleDown()

        return element
    }

    mutating public func add(_ element: Element) {
        elements.append(element)
        bubbleUp()
    }

    // Bubble
    mutating private func swapIndices(of this: Int, and that: Int) {
        (elements[this], elements[that]) = (elements[that], elements[this])
    }

    mutating private func bubbleDown() {
        var index = 0

        while hasChild(leftOf: index) {
            var child = getIndex(leftOf: index)
            if hasChild(rightOf: index), sort(right(from: index), left(from: index)) {
                child =  getIndex(rightOf: index)
            }

            guard sort(elements[child], elements[index]) else { break }

            swapIndices(of: index, and: child)
            index = child
        }
    }

    mutating private func bubbleUp() {
        var index = elements.count - 1

        while hasParent(of: index), sort(elements[index], parent(of: index)) {
            let parent = getParentIndex(of: index)
            swapIndices(of: index, and: parent)
            index = parent
        }
    }

    // Indices
    private func getIndex(leftOf parent: Int) -> Int { return 2 * parent + 1 }
    private func getIndex(rightOf parent: Int) -> Int { return 2 * parent + 2 }
    private func getParentIndex(of child: Int) -> Int { return (child - 1) / 2 }

    private func hasChild(leftOf parent: Int) -> Bool { return getIndex(leftOf: parent) < elements.count }
    private func hasChild(rightOf parent: Int) -> Bool { return getIndex(rightOf: parent) < elements.count }
    private func hasParent(of child: Int) -> Bool { return child >= 0 }

    private func left(from parent: Int) -> Element { return elements[getIndex(leftOf: parent)] }
    private func right(from parent: Int) -> Element { return elements[getIndex(rightOf: parent)] }
    private func parent(of child: Int) -> Element { return elements[getParentIndex(of: child)] }
}

extension Heap where Element: Comparable {
    public init() {
        self.init(using: <)
    }

    public init<Source>(from source: Source) where Source: Sequence, Source.Element == Element {
        self.init()
        for element in source { self.add(element) }
    }
}
