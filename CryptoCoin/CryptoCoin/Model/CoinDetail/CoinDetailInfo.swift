//
//  CoinDetaiInfo.swift
//  CoinCo
//
//  Created by 김도형 on 3/10/25.
//

import Foundation

struct CoinDetailInfo: Hashable {
    let title: String
    let value: Double
    let date: String?
    
    init(
        title: String,
        value: Double,
        date: String? = nil
    ) {
        self.title = title
        self.value = value
        self.date = date
    }
}
