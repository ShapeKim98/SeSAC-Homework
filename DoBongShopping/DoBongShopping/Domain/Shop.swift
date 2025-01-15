//
//  Shop.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct Shop {
    public let total: Int
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
        public let lprice: String
        public let mallName: String
    }
}

public extension ShopResponse.Item {
    func toEntity() -> Shop.Item {
        return Shop.Item(
            title: self.title.removeHTMLTags(),
            image: self.image,
            lprice: Int(self.lprice)?.formatted() ?? "",
            mallName: self.mallName.removeHTMLTags()
        )
    }
}

public extension ShopResponse {
    func toEntity() -> Shop {
        return Shop(
            total: self.total,
            page: Shop.Page(
                start: self.start,
                display: self.display
            ),
            list: self.items.map { $0.toEntity() }
        )
    }
}
