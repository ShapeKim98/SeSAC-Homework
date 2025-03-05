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
    private let folderProvider = RealmProvider<WishFolderTable>()
    
    func create(_ wish: Wish) throws {
        guard let wishTable = wish.toData() else { return }
        try provider.create(wishTable)
    }
    
    func create(_ wish: Wish, from: WishFolder) throws {
        guard
            let folder = from.toData(),
            let wishTable = wish.toData()
        else { return }
        try provider.write {
            folder.items.append(wishTable)
        }
    }
    
    func update(_ wish: Wish) throws {
        guard let wishTable = wish.toData() else { return }
        try provider.update(wishTable)
    }
    
    func readAll() -> [Wish] {
        provider.readAll().map { $0.toEntity() }
    }
    
    func read(_ primaryKey: UUID) -> Wish? {
        provider.read(primaryKey)?.toEntity()
    }
    
    func delete(_ wish: Wish) throws {
        guard let wishTable = wish.toData() else { return }
        try provider.delete(wishTable)
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
