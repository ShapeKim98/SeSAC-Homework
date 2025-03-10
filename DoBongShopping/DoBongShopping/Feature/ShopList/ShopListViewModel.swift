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

@MainActor
final class ShopListViewModel: Composable {
    enum Action {
        case collectionViewPrefetchItemsAt(items: [Int])
        case collectionViewWillDisplay(item: Int)
        case sortButtonTouchUpInside(sort: Sort)
        case bindShop(ShopResponse)
        case bindPaginationShop(ShopResponse)
        case bindErrorMessage(String)
        case errorAlertTapped
        case shopCollectionViewModel(ShopCollectionViewModel.Action)
    }
    
    struct State {
        var shop: ShopResponse
        var selectedSort: Sort = .sim
        var isLoading: Bool = false
        var query: String
        var errorMessage: String?
    }
    private var isPaging = false
    private var errorMessage: String?
    let shopCollectionViewModel: ShopCollectionViewModel
    
    @ComposableState var state: State
    
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init(query: String, shop: ShopResponse) {
        self.state = State(shop: shop, query: query)
        self.shopCollectionViewModel = ShopCollectionViewModel(shopItems: shop.items)
        
        bindSend()
        
        shopCollectionViewModel.send
            .map { Action.shopCollectionViewModel($0) }
            .bind(to: send)
            .disposed(by: disposeBag)
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
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
            shopCollectionViewModel.send.accept(.bindShopItems(shop.items))
            return .none
        case let .bindPaginationShop(shop):
            state.shop.items += shop.items
            isPaging = false
            shopCollectionViewModel.send.accept(.bindPaginationShopItems(shop.items))
            return .none
        case let .bindErrorMessage(message):
            state.errorMessage = message
            state.isLoading = false
            return .none
        case .errorAlertTapped:
            state.errorMessage = nil
            return .none
            
        case let .shopCollectionViewModel(.delegate(.collectionViewPrefetchItemsAt(items: items))):
            return .send(.collectionViewPrefetchItemsAt(items: items))
        case let .shopCollectionViewModel(.delegate(.collectionViewWillDisplay(item: item))):
            return .send(.collectionViewWillDisplay(item: item))
        case .shopCollectionViewModel:
            return .none
        }
    }
}

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
            guard let error = error as? BaseError else {
                print(error)
                return .none
            }
            return .send(.bindErrorMessage(error.errorMessage))
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
            guard let error = error as? BaseError else {
                print(error)
                return .none
            }
            return .send(.bindErrorMessage(error.errorMessage))
        }
    }
}
