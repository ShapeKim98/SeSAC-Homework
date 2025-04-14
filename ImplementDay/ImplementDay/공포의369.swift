//
//  Game369.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 공포의369() -> Int {
    let array = Array(1...10000000).map(\.description)
    
    var result = 0
    for num in array {
        let count = num.filter { n in
            return (n == "3" || n == "6" || n == "9")
        }.count
        
        result += count
    }
    return result
}
