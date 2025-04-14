//
//  행복한수.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 행복한_수() -> Int {
    var count = 0
    for n in 1...1000 {
        var result = n
        var temp = Set<Int>()
        recursive(depth: 0, base: n, n: &result, temp: &temp)
        if result == 1 {
            count += 1
        }
    }
    return count
}

func recursive(depth: Int, base: Int, n: inout Int, temp: inout Set<Int>) {
    if depth > 0 {
        if n == 1 { return }
        if temp.contains(n) { return }
    }
    
    var result = 0
    String(n).forEach { char in
        let value = Int(String(char))!
        result += (value * value)
    }
    temp.insert(n)
    n = result
    recursive(depth: depth + 1, base: base, n: &n, temp: &temp)
}
