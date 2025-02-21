//
//  Optional+Extension.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

extension Optional<Int> {
    static func += (lhs: inout Int?, rhs: Int?) {
        lhs = (lhs ?? 0) + (rhs ?? 0)
    }
}
