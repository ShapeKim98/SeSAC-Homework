//
//  main.swift
//  baekjoon9012
//
//  Created by 김도형 on 4/1/25.
//

import Foundation

struct Stack<T> {
    private var elements: [T] = []
    private let size: Int
    var count: Int { elements.count }
    
    init(size: Int) {
        self.size = size
        elements.reserveCapacity(size)
    }
}

extension Stack {
    /// Stack에 데이터 추가
    /// - Complexity: O(1)
    mutating func push(with element: T) {
        guard elements.count < size else {
            fatalError("stack over flow")
        }
        elements.append(element)
    }
    
    /// Stack에서 데이터 제거
    /// - Complexity: O(1)
    /// - Returns: 가장 최근에 들어온 데이터
    @discardableResult
    mutating func pop() -> T? {
        elements.popLast()
    }
    
    
    /// Stack의 최상단 데이터
    func top() -> T? {
        elements.last
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
        elements.description
    }
}

func solution(_ str: String) -> Bool {
    var stack = Stack<Character>(size: str.count)

    for char in str {
        if char == "(" {
            stack.push(with: "(")
        } else if char == ")" {
            let element = stack.pop()
            if element == nil {
                return false
            }
        }
    }

    return stack.count == 0
}

let t = Int(readLine()!)!

for _ in 0..<t {
    let str = readLine()!
    print(solution(str) ? "YES" : "NO")
}
