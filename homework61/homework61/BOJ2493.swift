//
//  BOJ2493.swift
//  homework61
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

func boj2493() {
    let _ = readLine()

    var inputs = readLine()!.split(separator: " ").compactMap { Int($0) }
    inputs.reverse()

    var result = Array(repeating: 0, count: inputs.count)

    var stack = [Int]()
    var index = inputs.count - 1
    while let top = inputs.popLast() {
        if let last = stack.last {
            if last < top {
                stack.append(top)
            } else {
                inputs.append(last)
            }
        } else {
            stack.append(top)
        }
        index -= 1
    }

    print(result.map(\.description).joined(separator: " "))
}
