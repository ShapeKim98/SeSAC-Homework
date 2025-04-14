//
//  main.swift
//  baekjoon1267
//
//  Created by 김도형 on 4/1/25.
//

import Foundation

let n = Int(readLine()!)!

let times = readLine()!.split(separator: " ").compactMap { Int($0) }

var yPrice = 0
var mPrice = 0

for time in times {
    yPrice += (time / 30 + 1) * 10
    mPrice += (time / 60 + 1) * 15
}
    
if yPrice < mPrice {
    print("Y \(yPrice)")
} else if mPrice < yPrice {
    print("M \(mPrice)")
} else {
    print("Y M \(yPrice)")
}
