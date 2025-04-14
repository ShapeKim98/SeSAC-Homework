//
//  WishFolderRepository.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol WishFolderRepositoryProtocol {
    func create(_ wishFolder: WishFolder) throws
    func update(_ wishFolder: WishFolder) throws
    func readAll() -> [WishFolder]
    func read(_ primaryKey: UUID) -> WishFolder?
    func delete(_ wishFolder: WishFolder) throws
    func observable() -> Observable<CollectionChange<[WishFolder]>>
}
