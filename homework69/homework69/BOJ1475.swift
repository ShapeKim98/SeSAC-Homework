//
//  BOJ1475.swift
//  homework69
//
//  Created by 김도형 on 4/21/25.
//

import Foundation

func boj1475() {
    let room = readLine()!.replacingOccurrences(of: "6", with: "9")
    var numbers = Array(repeating: 0.0, count: 10)
    for char in room {
        guard let num = Int(String(char)) else { continue }
        numbers[num] += 1
    }
    numbers[9] = ceil(numbers[9] / 2)
    print(Int(numbers.max() ?? 0))
}
