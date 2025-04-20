//
//  Bundle+Extension.swift
//  CoinCo
//
//  Created by 김도형 on 3/9/25.
//

import Foundation

extension Bundle {
    var coingeckoAPIKey: String {
        return infoDictionary?["COINGECKO_API_KEY"] as? String ?? ""
    }
    
    var coingeckoURL: String {
        return infoDictionary?["COINGECKO_URL"] as? String ?? ""
    }
}
