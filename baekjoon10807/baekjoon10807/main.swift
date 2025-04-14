//
//  main.swift
//  baekjoon10807
//
//  Created by 김도형 on 3/28/25.
//

import Foundation

let n = readLine()
let array = readLine()!.split(separator: " ")
let v = readLine()!
print(array.filter { $0 == v }.count)
