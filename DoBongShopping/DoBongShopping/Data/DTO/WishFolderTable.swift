//
//  WishFolderTable.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RealmSwift

class WishFolderTable: Object {
    @Persisted(primaryKey: true)
    var id: UUID
    @Persisted
    var name: String
    @Persisted
    var items: List<WishTable>
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

extension WishFolderTable {
    func toEntity() -> WishFolder {
        return WishFolder(
            id: self.id,
            name: self.name,
            items: self.items.map { $0.toEntity() },
            date: self.date
        )
    }
}

extension WishFolder {
    func toData() -> WishFolderTable {
        return WishFolderTable(
            id: self.id,
            name: self.name,
            date: self.date
        )
    }
}
