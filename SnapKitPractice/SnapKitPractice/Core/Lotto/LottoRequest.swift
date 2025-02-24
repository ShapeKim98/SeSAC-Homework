//
//  LottoRequest.swift
//  SnapKitPractice
//
//  Created by 김도형 on 2/24/25.
//

import Foundation

struct LottoRequest: Encodable {
    let drwNo: String
    let method: String
    
    init(drwNo: String) {
        self.drwNo = drwNo
        self.method = "getLottoNumber"
    }
}
