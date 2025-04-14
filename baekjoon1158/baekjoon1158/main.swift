//
//  main.swift
//  baekjoon1158
//
//  Created by 김도형 on 3/28/25.
//

import Foundation

let line = readLine()!.split(separator: " ").compactMap { Int($0) }
let (n, k) = (line[0], line[1])
var list = LinkedList<Int>()

for i in 1...n {
    list.insert(i, at: i - 1)
}
list.tail?.next = list.head
list.head?.prev = list.tail

var current: Node<Int>? = list.head
var count = 1
var result: [Int] = []
while list.count > 0 {
    if count == k {
        list.remove(at: current)
        count = 1
        result.append(current!.value)
    } else {
        count += 1
    }
    current = current?.next
}

print("<\(result.map(\.description).joined(separator: ", "))>")
