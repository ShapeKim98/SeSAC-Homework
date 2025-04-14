//
//  Queue.swift
//  homework61
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

struct Queue<T: Equatable> {
    private var list: LinkedList<T> = .init()
    
    var top: T? { list.head?.value }
    
    mutating func push(with element: T) {
        if list.isEmpty {
            list.prepend(element)
        } else {
            list.append(element)
        }
    }
    
    @discardableResult
    mutating func pop() -> T? {
        list.removeFirst()
    }
}
