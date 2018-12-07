//
//  Queue.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/6/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public struct Queue<Element> {
    fileprivate class Node {
        let value: Element
        var next: Node?

        init(value: Element) {
            self.value = value
            self.next = nil
        }
    }

    private var head: Node?
    private var tail: Node?

    public var count: Int = 0

    public init() { }

    public init<Source>(from items: Source) where Source: Collection, Element == Source.Element {
        for item in items {
            enqueue(item)
        }
    }

    public mutating func enqueue(_ item: Element) {
        let node = Node(value: item)

        if head == nil {
            head = node
            tail = node
        } else {
            tail?.next = node
            tail = node
        }

        count += 1
    }

    public mutating func enqueue<Source>(all items: Source) where Source: Collection, Element == Source.Element {
        for item in items {
            enqueue(item)
        }
    }

    public mutating func dequeue() -> Element? {
        guard let item = head?.value else { return nil }
        head = head?.next
        count -= 1
        return item
    }
}

extension Queue: Sequence, IteratorProtocol {
    public mutating func next() -> Element? {
        return dequeue()
    }
}
