//
//  FavoriteListViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

@MainActor
final class FavoriteListViewModel: Composable {
    enum Action {
        case viewDidLoad
        case observeShopItemTable
        case bindShopItems([ShopResponse.Item])
        case bindRealm
        case searchTestFieldTextOnChanged(String)
    }
    
    struct State {
        var text = ""
    }
    
    @ComposableState var state = State()
    
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    @RealmTable
    var shopItemTable: Results<ShopItemTable>
    
    let shopCollectionViewModel = ShopCollectionViewModel(shopItems: [])
    
    init() { bindSend() }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            let shopItems = shopItemTable.map { $0.toData() }
            return .merge(
                .send(.bindShopItems(Array(shopItems))),
                .send(.observeShopItemTable)
            )
        case .observeShopItemTable:
            return .run($shopItemTable.observable.map { _ in Action.bindRealm })
        case let .bindShopItems(shopItems):
            shopCollectionViewModel.send.accept(.bindShopItems(shopItems))
            return .none
        case let .searchTestFieldTextOnChanged(text):
            state.text = text
            return fetchShopItems(state.text)
        case .bindRealm:
            return fetchShopItems(state.text)
        }
    }
}

private extension FavoriteListViewModel {
    func fetchShopItems(_ text: String) -> Observable<Effect<Action>> {
        guard !text.isEmpty else {
            let results = shopItemTable.map { $0.toData() }
            return .send(.bindShopItems(Array(results)))
        }
        
        return .run { effect in
            @RealmTable var table: Results<ShopItemTable>
            let results = table.where { query in
                query.title.contains(text, options: .caseInsensitive)
                || query.mallName.contains(text, options: .caseInsensitive)
            }.map { $0.toData() }
            effect.onNext(.send(.bindShopItems(Array(results))))
        }
    }
}
