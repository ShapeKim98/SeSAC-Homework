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
        case bindToken(NotificationToken?)
    }
    
    struct State {
        
    }
    
    @ComposableState var state = State()
    
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    @RealmTable
    var shopItemTable: Results<ShopItemTable>
    var token: NotificationToken?
    
    lazy var shopCollectionViewModel = ShopCollectionViewModel(shopItems: [])
    
    init() { bindSend() }
    
    deinit { token?.invalidate() }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            let shopItems = shopItemTable.map { $0.toData() }
            return .merge(
                .send(.bindShopItems(Array(shopItems))),
                .send(.observeShopItemTable)
            )
        case .observeShopItemTable:
            return .run($shopItemTable.observable.map { table in
                Action.bindShopItems(table.map { $0.toData() })
            })
        case let .bindShopItems(shopItems):
            shopCollectionViewModel.send.accept(.bindShopItems(shopItems))
            return .none
        case let .bindToken(token):
            self.token = token
            return .none
        }
    }
}
