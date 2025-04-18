//
//  ShopClient.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/16/25.
//

import SwiftUI

actor ShopClient {
    private let provider = NetworkProvider<ShopEndPoint>()
    
    func fetchShop(_ model: ShopRequest) async throws -> Shop {
        try await provider.request(.fetchShop(model))
    }
}

extension ShopClient: EnvironmentKey {
    static let defaultValue = ShopClient()
}

extension EnvironmentValues {
    var shopClient: ShopClient {
        get { self[ShopClient.self] }
        set { self[ShopClient.self] = newValue }
    }
}
