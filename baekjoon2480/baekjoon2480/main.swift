//
//  main.swift
//  baekjoon2480
//
//  Created by 김도형 on 4/3/25.
//

import Foundation

let input = readLine()!.split(separator: " ").compactMap { Int($0) }

var maxValue = 1
var maxCount = 0
for n in 1...6 {
    let count = input.filter { $0 == n }.count
    guard count >= maxCount else { continue}
    maxValue = n
    maxCount = count
}

if maxCount == 3 {
    print(10000 + (maxValue * 1000))
} else if maxCount == 2 {
    print(1000 + (maxValue * 100))
} else {
    print(maxValue * 100)
}
