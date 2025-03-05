//
//  WishTable.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RealmSwift

class WishTable: Object {
    @Persisted(primaryKey: true)
    var id: UUID
    @Persisted
    var name: String
    @Persisted
    var date: Date
    
    convenience init(
        id: UUID = .init(),
        name: String,
        date: Date = .now
    ) {
        self.init()
        
        self.id = id
        self.name = name
        self.date = date
    }
}

extension WishTable {
    func toEntity() -> Wish {
        return Wish(
            id: self.id,
            name: self.name,
            date: self.date
        )
    }
}

extension Wish {
    func toData() -> WishTable {
        return WishTable(
            id: self.id,
            name: self.name,
            date: self.date
        )
    }
}
