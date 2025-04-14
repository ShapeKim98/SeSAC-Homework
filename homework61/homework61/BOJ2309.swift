//
//  BOJ2309.swift
//  homework61
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

func boj2309() {
    var heights = [Int]()
    var total = 0
    for _ in 0..<9 {
        let n = Int(readLine()!)!
        heights.append(n)
        total += n
    }

    let diff = total - 100
    heights.sort()
    let temps = heights
    for (i, height) in temps.enumerated() {
        let value = diff - height
        
        guard value > 0 else { continue }
        guard heights.contains(value) else { continue }
        heights.remove(at: i)
        guard let j = heights.firstIndex(of: value) else { continue }
        heights.remove(at: j)
        break
    }

    print(heights.map(\.description).joined(separator: "\n"))
}
