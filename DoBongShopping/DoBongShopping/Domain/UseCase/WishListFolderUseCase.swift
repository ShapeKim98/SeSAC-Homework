//
//  WishListFolderUseCase.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WishListFolderUseCase {
    private let wishFolderRepository: WishFolderRepositoryProtocol
    
    init(wishFolderRepository: WishFolderRepositoryProtocol) {
        self.wishFolderRepository = wishFolderRepository
    }
    
    func create(_ wishFolder: WishFolder) throws {
        try wishFolderRepository.create(wishFolder)
    }
    
    func readAll() -> [WishFolder] {
        wishFolderRepository.readAll()
    }
    
    func read(_ primaryKey: UUID) -> WishFolder? {
        wishFolderRepository.read(primaryKey)
    }
    
    func observable() -> Observable<CollectionChange<[WishFolder]>> {
        wishFolderRepository.observable()
    }
}
