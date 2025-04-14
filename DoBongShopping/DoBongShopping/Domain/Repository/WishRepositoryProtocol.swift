//
//  WishRepositoryProtocol.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol WishRepositoryProtocol {
    func create(_ wish: Wish) throws
    func update(_ wish: Wish) throws
    func readAll() -> [Wish]
    func read(_ primaryKey: UUID) -> Wish?
    func delete(_ wish: Wish) throws
    func observable() -> Observable<CollectionChange<[Wish]>>
    func create(_ wish: Wish, from: WishFolder) throws
}
