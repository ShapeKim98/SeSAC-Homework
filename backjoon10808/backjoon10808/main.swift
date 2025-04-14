//
//  main.swift
//  backjoon10808
//
//  Created by 김도형 on 3/28/25.
//

import Foundation

let line = readLine()!

/// a ~ z
/// 0 25
///
///  8 = 1000
///  9 = 1001
///  문자를 이진수로 표현하는 방법 = 아스키 코드
///  beakjoon
///  b = 98 - "a".아스키코드 값 (97) = 1

var vis: [Int] = Array(repeating: 0, count: 26)
for char in line {
    vis[Int(char.asciiValue!) - Int(UnicodeScalar("a").value)] += 1
}

/// 1 1 0 0 1 0 0 0 0 1 1
/// ["1", "1", "0"...]
let a = vis.map { String($0) }.joined(separator: " ")
print(a)

//for char in line {
//    switch char {
//    case "a": result[0] += 1
//    case "b": result[1] += 1
//    case "c": result[2] += 1
//    case "d": result[3] += 1
//    case "e": result[4] += 1
//    case "f": result[5] += 1
//    case "g": result[6] += 1
//    case "h": result[7] += 1
//    case "i": result[8] += 1
//    case "j": result[9] += 1
//    case "k": result[10] += 1
//    case "l": result[11] += 1
//    case "m": result[12] += 1
//    case "n": result[13] += 1
//    case "o": result[14] += 1
//    case "p": result[15] += 1
//    case "q": result[16] += 1
//    case "r": result[17] += 1
//    case "s": result[18] += 1
//    case "t": result[19] += 1
//    case "u": result[20] += 1
//    case "v": result[21] += 1
//    case "w": result[22] += 1
//    case "x": result[23] += 1
//    case "y": result[24] += 1
//    case "z": result[25] += 1
//    default:
//        break
//    }
//}
//
//result.forEach { print($0, terminator: " ") }
