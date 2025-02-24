//
//  LottoError.swift
//  SnapKitPractice
//
//  Created by 김도형 on 2/24/25.
//

import Foundation

struct LottoError: Error, Decodable {
    var returnValue: String
}
