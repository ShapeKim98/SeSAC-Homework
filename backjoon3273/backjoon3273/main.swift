//
//  main.swift
//  backjoon3273
//
//  Created by 김도형 on 3/28/25.
//

import Foundation

let n = Int(readLine()!)!
let arr = readLine()!.split(separator: " ").map { Int($0)! }
let x = Int(readLine()!)!

var vis: [Bool] = .init(repeating: false, count: x + 2)
var answer = 0

for elem in arr where elem < x {
    vis[elem] = true
}

for elem in arr where elem < x {
    if vis[x - elem] { answer += 1 }
}

print(answer / 2)
