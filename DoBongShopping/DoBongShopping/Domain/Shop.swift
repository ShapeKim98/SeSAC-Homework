//
//  Shop.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct Shop {
    public let page: Page
    public let list: [Item]
}

extension Shop {
    public struct Page {
        public let start: Int
        public let display: Int
    }
}

extension Shop {
    public struct Item {
        public let title: String
        public let image: String
        public let lprice: Int
        public let mallName: String
    }
}
