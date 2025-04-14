//
//  main.swift
//  baekjoon1919
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

var str1 = readLine()!
var str2 = readLine()!

var stack = [Character]()

while let char = str1.popLast() {
    stack.append(char)
    if let index = str2.firstIndex(of: char) {
        let _ = stack.popLast()
        str2.remove(at: index)
    }
}

while let char = str2.popLast() {
    stack.append(char)
    if let index = str1.firstIndex(of: char) {
        let _ = stack.popLast()
        str1.remove(at: index)
    }
}

print(stack.count)
