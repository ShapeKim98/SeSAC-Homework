//
//  WebViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class WebViewModel: Composable {
    enum Action {
        case favoriteButtonTapped
    }
    
    struct State {
        @Shared(.userDefaults(.favoriteItems, defaultValue: [String: Bool]()))
        var favoriteItems: [String: Bool]?
        let item: ShopResponse.Item
        var isFavorite: Bool {
            favoriteItems?[item.productId] ?? false
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
            if state.favoriteItems?[productId] ?? false {
                state.favoriteItems?.removeValue(forKey: productId)
            } else {
                state.favoriteItems?.updateValue(true, forKey: productId)
            }
            return .none
        }
    }
}
