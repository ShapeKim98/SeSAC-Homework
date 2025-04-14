//
//  숫자챌린지.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 숫자_챌린지() -> String {
    let binaryString = String(266, radix: 2)
    print(binaryString)
    var challengeNumber = ""
    for char in binaryString {
        if char == "0" {
            challengeNumber.append("4")
        } else if char == "1" {
            challengeNumber.append("7")
        }
    }
    return challengeNumber
}
