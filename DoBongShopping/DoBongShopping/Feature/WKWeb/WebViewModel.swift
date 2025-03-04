//
//  WebViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

@MainActor
final class WebViewModel: Composable {
    enum Action {
        case favoriteButtonTapped
    }
    
    struct State {
        @RealmTable
        var shopItemTable: Results<ShopItemTable>
        let item: ShopResponse.Item
        var isFavorite: Bool {
            $shopItemTable.findObject(item.productId) != nil
        }
    }
    
    @ComposableState var state: State
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init(item: ShopResponse.Item) {
        state = State(item: item)
        
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .favoriteButtonTapped:
            let productId = state.item.productId
            let item = state.$shopItemTable.findObject(productId)
            
            do {
                if let item {
                    try state.$shopItemTable.delete(item)
                } else {
                    try state.$shopItemTable.create(state.item.toObject())
                }
            } catch {
                
            }
            return .none
        }
    }
}
