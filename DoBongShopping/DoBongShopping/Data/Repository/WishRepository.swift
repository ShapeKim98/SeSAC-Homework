//
//  WishRepository.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WishRepository: WishRepositoryProtocol {
    private let provider = RealmProvider<WishTable>()
    
    func create(_ wish: Wish) throws {
        try provider.create(wish.toData())
    }
    
    func create(_ wish: Wish, from: WishFolder) throws {
        let folderProvider = RealmProvider<WishFolderTable>()
        guard let folderTable = folderProvider.read(from.id) else {
            return
        }
        
        try provider.write {
            folderTable.items.append(wish.toData())
        }
    }
    
    func update(_ wish: Wish) throws {
        try provider.update(wish.id)
    }
    
    func readAll() -> [Wish] {
        provider.readAll().map { $0.toEntity() }
    }
    
    func read(_ primaryKey: UUID) -> Wish? {
        provider.read(primaryKey)?.toEntity()
    }
    
    func delete(_ wish: Wish) throws {
        try provider.delete(wish.id)
    }
    
    func observable() -> RxSwift.Observable<CollectionChange<[Wish]>> {
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
