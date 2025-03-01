//
//  SearchViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

@MainActor
final class SearchViewModel: Composable {
    enum Action {
        case searchBarSearchButtonClicked(_ text: String)
        case bindShop(ShopResponse)
        case bindErrorMessage(String)
        case errorAlertTapped
        case alertTapped
        case navigationDidPop
    }
    
    struct State {
        @ComposableState
        var shop: ShopResponse?
        var isLoading: Bool = false
        var errorMessage: String?
        var alertMessage: String?
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init() { bindSend() }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .searchBarSearchButtonClicked(query):
            guard query.filter(\.isLetter).count >= 2 else {
                state.alertMessage = "두 글자 이상 입력해주세요."
                return .none
            }
            guard !query.filter(\.isLetter).isEmpty else {
                state.alertMessage = "글자를 포함해주세요."
                return .none
            }
            state.isLoading = true
            return .run { effect in
                let request = ShopRequest(query: query)
                let shop = try await ShopClient.shared.fetchShop(request)
                effect.onNext(.send(.bindShop(shop)))
            } catch: { error in
                guard let error = error as? BaseError else {
                    print(error)
                    return .none
                }
                return .send(.bindErrorMessage(error.errorMessage))
            }
        case let .bindShop(shop):
            defer { state.isLoading = false }
            guard shop.total > 0 else {
                state.alertMessage = "검색 결과가 없어요."
                return .none
            }
            state.shop = shop
            return .none
        case let .bindErrorMessage(message):
            state.errorMessage = message
            state.isLoading = false
            return .none
        case .errorAlertTapped:
            state.errorMessage = nil
            return .none
        case .alertTapped:
            state.alertMessage = nil
            return .none
        case .navigationDidPop:
            state.shop = nil
            return .none
        }
    }
}
