//
//  Sample.swift
//  02_List
//
//  Created by Bran on 3/26/25.
//

import Foundation

final class Node<T: Equatable> {
    var value: T
    var prev: Node?
    var next: Node?
    
    init(value: T,
         prev: Node? = nil,
         next: Node? = nil) {
        self.value = value
        self.prev = prev
        self.next = next
    }
}

extension Node: Equatable {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        lhs.value == rhs.value && lhs.next == rhs.next
    }
}
