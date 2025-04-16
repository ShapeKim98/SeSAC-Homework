//
//  MarketPrice.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//

import Foundation

struct MarketPrice: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let fluctuation: Double
}

extension [MarketPrice] {
    static let sample: [MarketPrice] = [
        MarketPrice(name: "코스피", price: 2477.41, fluctuation: 0.8),
        MarketPrice(name: "코스닥", price: 711.92, fluctuation: 0.4),
        MarketPrice(name: "나스닥", price: 16831.48, fluctuation: 0.6),
        MarketPrice(name: "S&P 500", price: 5405.97, fluctuation: 0.7),
        MarketPrice(name: "환율", price: 1426.80, fluctuation: -0.04),
    ]
}
