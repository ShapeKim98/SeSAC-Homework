//
//  Node.swift
//  LinkedListQueue
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

class Node<T> {
    let value: T
    var prev: Node?
    var next: Node?
    
    init(value: T) {
        self.value = value
    }
}
