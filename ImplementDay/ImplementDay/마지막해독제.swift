//
//  LastAntidote.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 마지막_해독제() -> Int {
    let times = "7 3 15 2 9 11 6 13 5 8 14 1 19 4 21 17 12 10 18 20 16 22 25 23 24"
        .split(separator: " ").compactMap { Int($0) }.sorted()
    
    var result = 0
    var sum = 0
    for time in times {
        sum += time
        result += sum
    }
    return result
}
