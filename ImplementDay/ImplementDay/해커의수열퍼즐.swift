//
//  SequencePuzzle.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 해커의_수열_퍼즐(i: Int) -> Int {
    if i == 1 { return 1 }
    if i == 2 { return 2 }
    if i == 3 { return 3 }
    if i == 4 { return 4 }
    if i == 5 { return 19 }
    
    return 2 * 해커의_수열_퍼즐(i: i - 1)
    + 3 * 해커의_수열_퍼즐(i: i - 2)
    - 해커의_수열_퍼즐(i: i - 3)
    + 4 * 해커의_수열_퍼즐(i: i - 4)
}
