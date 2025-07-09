//
//  CoinGeckoError.swift
//  CoinCo
//
//  Created by 김도형 on 3/11/25.
//

import Foundation

struct CoinGeckoError: Error, Decodable {
    let error: String
}
