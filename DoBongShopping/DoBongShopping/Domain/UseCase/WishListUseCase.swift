//
//  WishListUseCase.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WishListUseCase {
    private let wishRepository: WishRepositoryProtocol
    
    init(wishRepository: WishRepositoryProtocol) {
        self.wishRepository = wishRepository
    }
    
    func create(_ wish: Wish, from: WishFolder) throws {
        try wishRepository.create(wish, from: from)
    }
    
    func delete(_ wish: Wish) throws {
        try wishRepository.delete(wish)
    }
    
    func readAll() -> [Wish] {
        wishRepository.readAll()
    }
    
    func observable() -> Observable<CollectionChange<[Wish]>> {
        wishRepository.observable()
    }
}
