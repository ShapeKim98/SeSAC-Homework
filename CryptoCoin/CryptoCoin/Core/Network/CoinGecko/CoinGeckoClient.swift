//
//  CoinGeckoClient.swift
//  CoinCo
//
//  Created by 김도형 on 3/9/25.
//

import Foundation

final class CoinGeckoClient {
    static let shared = CoinGeckoClient()
    
    private let provider = NetworkProvider<CoinGeckoEndPoint>()
    
    private init() {}
    
    func fetchTrending() async throws -> Trending {
        try await provider.request(.trending)
    }
    
    func fetchSearch(_ model: SearchRequest) async throws -> Search {
        try await provider.request(.search(model))
    }
    
    func fetchCoinDetail(_ model: CoinDetailRequest) async throws -> [CoinDetail] {
        try await provider.request(.markets(model))
    }
}
