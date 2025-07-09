//
//  CoinGeckoClient.swift
//  CoinCo
//
//  Created by 김도형 on 3/9/25.
//

import SwiftUI

import Dependencies
import DependenciesMacros

@DependencyClient
struct CoinGeckoClient {
    var fetchTrending: () async throws -> Trending
    var fetchSearch: (
        _ model: SearchRequest
    ) async throws -> Search
    var fetchCoinDetail: (
        _ model: CoinDetailRequest
    ) async throws -> [CoinDetail]
}

extension CoinGeckoClient: DependencyKey {
    static let liveValue: CoinGeckoClient = {
        let provider = NetworkProvider<CoinGeckoEndPoint>()
        return CoinGeckoClient(
            fetchTrending: {
                try await provider.request(.trending)
            },
            fetchSearch: { model in
                try await provider.request(.search(model))
            },
            fetchCoinDetail: { model in
                try await provider.request(.markets(model))
            }
        )
    }()
}

extension CoinGeckoClient: TestDependencyKey {
    static let testValue: CoinGeckoClient = CoinGeckoClient(
        fetchTrending: {
            try? await Task.sleep(for: .seconds(1))
            return .mock
        },
        fetchSearch: { _ in
            try? await Task.sleep(for: .seconds(1))
            return .mock
        },
        fetchCoinDetail: { _ in
            try? await Task.sleep(for: .seconds(1))
            return [CoinDetail.mock]
        }
    )
    
    static let previewValue: CoinGeckoClient = testValue
}
