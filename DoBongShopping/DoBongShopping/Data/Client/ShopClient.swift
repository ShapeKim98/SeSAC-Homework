//
//  ShopClient.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

import Alamofire

actor ShopClient {
    static let shared = ShopClient()
    
    private let manager = NetworkProvider<ShopEndPoint>()
    
    private init() { }
    
    func fetchShop(_ model: ShopRequest) async throws -> ShopResponse {
        try await manager.request(
            ShopEndPoint.fetchShop(model)
        )
    }
}
