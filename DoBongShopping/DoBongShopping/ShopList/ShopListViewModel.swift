//
//  ShopListViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import Foundation

import RxSwift
import RxCocoa
import Alamofire

final class ShopListViewModel: Composable {
    enum Action {
        case collectionViewPrefetchItemsAt(items: [Int])
        case collectionViewWillDisplay(item: Int)
        case sortButtonTouchUpInside(sort: Sort)
        case bindShop(ShopResponse)
        case bindPaginationShop(ShopResponse)
    }
    
    struct State {
        var shop: ShopResponse
        var selectedSort: Sort = .sim
        var isLoading: Bool = false
        var query: String
    }
    private var isPaging = false
    
    private let state: BehaviorRelay<State>
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    @MainActor
    init(query: String, shop: ShopResponse) {
        self.state = BehaviorRelay(value: State(shop: shop, query: query))
        
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
    
    @MainActor
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .collectionViewPrefetchItemsAt(items):
            for item in items {
                guard item + 1 == state.shop.items.count else { continue }
                return paginationShop(&state, query: state.query)
            }
            return .none
        case let .collectionViewWillDisplay(item):
            guard item + 1 == state.shop.items.count else { return .none }
            return paginationShop(&state, query: state.query)
        case let .sortButtonTouchUpInside(sort):
            state.selectedSort = sort
            state.isLoading = true
            return fetchShop(&state, query: state.query)
        case let .bindShop(shop):
            state.shop = shop
            state.isLoading = false
            return .none
        case let .bindPaginationShop(shop):
            state.shop.items += shop.items
            isPaging = false
            return .none
        }
    }
}

@MainActor
private extension ShopListViewModel {
    func fetchShop(_ state: inout State, query: String) -> Observable<Effect<Action>> {
        state.isLoading = true
        return .run { [ sort = state.selectedSort.rawValue ] effect in
            let request = ShopRequest(
                query: query,
                sort: sort
            )
            let response = try await ShopClient.shared.fetchShop(request)
            effect.onNext(.send(.bindShop(response)))
        } catch: { error in
            print((error as? AFError) ?? error)
            return .none
        }
    }
    
    func paginationShop(_ state: inout State, query: String) -> Observable<Effect<Action>> {
        guard
            !isPaging,
            state.shop.items.count < state.shop.total
        else { return .none }
        isPaging = true
        
        return .run { [
            count = state.shop.items.count + 1,
            sort = state.selectedSort.rawValue
        ] effect in
            let request = ShopRequest(
                query: query,
                start: count,
                sort: sort
            )
            let response = try await ShopClient.shared.fetchShop(request)
            effect.onNext(.send(.bindPaginationShop(response)))
        } catch: { error in
            print((error as? AFError) ?? error)
            return .none
        }
    }
}
