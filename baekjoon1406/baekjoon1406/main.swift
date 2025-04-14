//
//  main.swift
//  baekjoon1406
//
//  Created by 김도형 on 3/28/25.
//

import Foundation

var str = readLine()!
var list = LinkedList<String>()
str.enumerated().forEach { index, char in
    list.insert(String(char), at: index)
}

let m = Int(readLine()!)!
var cursor: Node? = Node(value: "")
cursor?.prev = list.tail

for _ in 0..<m {
    let input = readLine()!.split(separator: " ")
    switch input[0] {
    case "L":
        guard cursor?.prev != nil else { continue }
        cursor?.next = cursor?.prev
        cursor?.prev = cursor?.prev?.prev
    case "D":
        guard cursor?.next != nil else { continue }
        cursor?.prev = cursor?.next
        cursor?.next = cursor?.next?.next
    case "B":
        guard cursor?.prev != nil else { continue }
    
        if cursor?.prev?.prev == nil {
            list.removeFirst()
            cursor?.prev = nil
        } else if cursor?.next == nil {
            cursor?.prev = list.tail?.prev
            list.removeLast()
        } else {
            list.remove(at: cursor?.prev)
            cursor?.prev = cursor?.prev?.prev
        }
    case "P":
        if cursor?.prev == nil {
            list.prepend(String(input[1]))
            cursor?.prev = list.head
        } else if cursor?.next == nil {
            list.append(String(input[1]))
            cursor?.prev = list.tail
        } else {
            let newNode = list.insert(before: cursor?.next, String(input[1]))
            cursor?.prev = newNode
        }
    default: continue
    }
}

var current = list.head
while current != nil {
    print(current!.value, terminator: "")
    current = current?.next
}
print("")
