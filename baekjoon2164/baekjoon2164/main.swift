//
//  main.swift
//  baekjoon2164
//
//  Created by 김도형 on 4/3/25.
//

import Foundation

let n = Int(readLine()!)!

//var queue = [Int]()
//for i in 1...n {
//    queue.append(i)
//}
//
//while queue.count > 1 {
//    queue.removeFirst()
//    let value = queue.removeFirst()
//    queue.append(value)
//}
//
//print(queue.first!)

//struct QueueWithArrayPointer<T> {
//    private var elements: [T] = []
//    private var front = 0
//    
//    var isEmpty: Bool {
//        count == 0
//    }
//    
//    var count: Int {
//        elements.count - front
//    }
//    
//    mutating func push(with element: T) {
//        elements.append(element)
//    }
//    
//    @discardableResult
//    mutating func pop() -> T? {
//        guard !isEmpty else { return nil }
//        let value = elements[front]
//        front += 1
//        return value
//    }
//    
//    func top() -> T? {
//        guard !isEmpty else { return nil }
//        return elements[front]
//    }
//}
//
//var queue = QueueWithArrayPointer<Int>()
//for i in 1...n {
//    queue.push(with: i)
//}
//
//while queue.count > 1 {
//    queue.pop()
//    queue.push(with: queue.pop()!)
//}
//
//print(queue.pop()!)

var queue = [Int]()
var front = 0

for i in 1...n {
    queue.append(i)
}

while queue.count - front > 1 {
    front += 1
    queue.append(queue[front])
    front += 1
}

print(queue[front])
