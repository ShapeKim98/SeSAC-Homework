//
//  ShopResponse.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct ShopResponse: Decodable {
    public let total: Int
    public let start: Int
    public let display: Int
    public let items: [Item]
}

extension ShopResponse {
    public struct Item: Decodable {
        public let title: String
        public let image: String
        public let lprice: Int
        public let mailName: String
    }
}
