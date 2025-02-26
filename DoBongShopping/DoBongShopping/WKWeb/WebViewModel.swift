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
            print(favoriteItems)
            return favoriteItems?[item.productId] ?? false
        }
    }
    
    private let state: BehaviorRelay<State>
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    init(item: ShopResponse.Item) {
        state = BehaviorRelay(value: State(item: item))
        
        send
            .observe(on: MainScheduler.asyncInstance)
            .debug("\(Self.self): Received Action")
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state.value
                this.reducer(&state, action)
                    .observe(on: MainScheduler.asyncInstance)
                    .compactMap(\.action)
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
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
