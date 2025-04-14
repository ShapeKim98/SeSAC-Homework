//
//  main.swift
//  baekjoon10804
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

var array = Array(repeating: 0, count: 20)
for i in 1...20 {
    array[i - 1] = i
}

for _ in 0..<10 {
    let range = readLine()!.split(separator: " ").compactMap { Int($0) }
    let (start, end) = (range[0], range[1])
    var stack = [Int]()
    for i in (start - 1)..<end {
        stack.append(array[i])
    }
    for i in (start - 1)..<end {
        array[i] = stack.removeLast()
    }
}

print(array.map(\.description).joined(separator: " "))
