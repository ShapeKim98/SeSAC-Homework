//
//  WishFolderRepository+LiveKey.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WishFolderRepository: WishFolderRepositoryProtocol {
    private let provider = RealmProvider<WishFolderTable>()
    
    func create(_ wishFolder: WishFolder) throws {
        try provider.create(wishFolder.toData())
    }
    
    func update(_ wishFolder: WishFolder) throws {
        try provider.update(wishFolder.id)
    }
    
    func readAll() -> [WishFolder] {
        provider.readAll().map { $0.toEntity() }
    }
    
    func read(_ primaryKey: UUID) -> WishFolder? {
        provider.read(primaryKey)?.toEntity()
    }
    
    func delete(_ wishFolder: WishFolder) throws {
        try provider.delete(wishFolder.id)
    }
    
    func observable() -> Observable<CollectionChange<[WishFolder]>> {
        provider.observable()
            .map { changes in
                switch changes {
                case let .initial(collection):
                    return .initial(collection.map { $0.toEntity() })
                case let .update(collection, deletions, insertions, modifications):
                    return .update(collection.map { $0.toEntity() }, deletions: deletions, insertions: insertions, modifications: modifications)
                case let .error(error):
                    return .error(error)
                }
            }
    }
}
