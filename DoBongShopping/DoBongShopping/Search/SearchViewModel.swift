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
    }
    
    struct State {
        var shop: ShopResponse?
        var isLoading: Bool = false
        var errorMessage: String?
        var alertMessage: String?
    }
    
    private var errorMessage: String?
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    init() {
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
        case let .searchBarSearchButtonClicked(query):
            guard query.filter(\.isLetter).count >= 2 else {
                state.alertMessage = "두 글자 이상 입력해주세요."
                return .none
            }
            guard !query.filter(\.isLetter).isEmpty else {
                state.alertMessage = "글자를 포함해주세요."
                return .none
            }
            state.shop = nil
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
        }
    }
}
