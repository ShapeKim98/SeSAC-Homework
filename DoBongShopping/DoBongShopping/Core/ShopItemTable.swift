//
//  ShopItemTable.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import Foundation

import RealmSwift

class ShopItemTable: Object {
    @Persisted(primaryKey: true)
    var productId: String
    @Persisted(indexed: true)
    var title: String
    @Persisted
    var image: String
    @Persisted
    var lprice: String
    @Persisted(indexed: true)
    var mallName: String
    @Persisted
    var link: String
    @Persisted
    var addDate: Date
    
    convenience init(
        productId: String,
        title: String,
        image: String,
        lprice: String,
        mallName: String,
        link: String,
        addDate: Date = .now
    ) {
        self.init()
        
        self.productId = productId
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.link = link
    }
}

extension ShopItemTable {
    func toData() -> ShopResponse.Item {
        return ShopResponse.Item(
            productId: self.productId,
            title: self.title,
            image: self.image,
            lprice: self.lprice,
            mallName: self.mallName,
            link: self.link
        )
    }
}

extension ShopResponse.Item {
    func toObject() -> ShopItemTable {
        return ShopItemTable(
            productId: self.productId,
            title: self.title,
            image: self.image,
            lprice: self.lprice,
            mallName: self.mallName,
            link: self.link
        )
    }
}
