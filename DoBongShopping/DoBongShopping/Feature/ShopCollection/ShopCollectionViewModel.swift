//
//  ShopCollectionViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class ShopCollectionViewModel: Composable {
    enum Action {
        case collectionViewPrefetchItemsAt(items: [Int])
        case collectionViewWillDisplay(item: Int)
        case collectionViewModelSelected(ShopResponse.Item)
        case bindShopItems([ShopResponse.Item])
        case bindPaginationShopItems([ShopResponse.Item])
        case delegate(Delegate)
        
        enum Delegate {
            case collectionViewPrefetchItemsAt(items: [Int])
            case collectionViewWillDisplay(item: Int)
        }
    }
    
    struct State {
        var shopItems: [ShopResponse.Item]
        @PresentState
        var selectedItem: ShopResponse.Item?
    }
    
    @ComposableState var state: State
    
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init(shopItems: [ShopResponse.Item]) {
        self.state = State(shopItems: shopItems)
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .collectionViewPrefetchItemsAt(let items):
            return .send(.delegate(.collectionViewPrefetchItemsAt(items: items)))
        case .collectionViewWillDisplay(let item):
            return .send(.delegate(.collectionViewWillDisplay(item: item)))
        case let .bindPaginationShopItems(shopItems):
            state.shopItems += shopItems
            return .none
        case let .bindShopItems(shopItems):
            state.shopItems = shopItems
            return .none
        case let .collectionViewModelSelected(item):
            state.selectedItem = item
            return .none
        case .delegate: return .none
        }
    }
}
