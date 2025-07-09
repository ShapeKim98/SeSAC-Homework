//
//  CoinDetailRequest.swift
//  CoinCo
//
//  Created by 김도형 on 3/11/25.
//

import Foundation

struct CoinDetailRequest: Encodable {
    let vsCurrency: String
    let ids: String
    let sparkline: Bool
    
    enum CodingKeys: String, CodingKey {
        case vsCurrency = "vs_currency"
        case ids
        case sparkline
    }
    
    init(
        vsCurrency: String = "krw",
        ids: String,
        sparkline: Bool = true
    ) {
        self.vsCurrency = vsCurrency
        self.ids = ids
        self.sparkline = sparkline
    }
}
