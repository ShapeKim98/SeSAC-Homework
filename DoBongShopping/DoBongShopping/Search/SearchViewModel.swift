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
protocol SearchViewModelDelegate: AnyObject {
    func pushShopList(query: String, shop: ShopResponse)
    func presentAlert(title: String?, message: String?, action: (() -> Void)?)
}

@MainActor
final class SearchViewModel: Composable {
    enum Action {
        case searchBarSearchButtonClicked(_ text: String)
        case bindShop(String, ShopResponse)
        case bindErrorMessage(String)
    }
    
    struct State {
        var isLoading: Bool = false
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
    
    weak var delegate: (any SearchViewModelDelegate)?
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .searchBarSearchButtonClicked(query):
            guard query.filter(\.isLetter).count >= 2 else {
                delegate?.presentAlert(
                    title: "두 글자 이상 입력해주세요.",
                    message: nil,
                    action: nil
                )
                return .none
            }
            guard !query.filter(\.isLetter).isEmpty else {
                delegate?.presentAlert(
                    title: "글자를 포함해주세요.",
                    message: nil,
                    action: nil
                )
                return .none
            }
            state.isLoading = true
            return .run { effect in
                let request = ShopRequest(query: query)
                let shop = try await ShopClient.shared.fetchShop(request)
                effect.onNext(.send(.bindShop(query, shop)))
            } catch: { error in
                guard let error = error as? BaseError else {
                    print(error)
                    return .none
                }
                return .send(.bindErrorMessage(error.errorMessage))
            }
        case let .bindShop(query, shop):
            defer { state.isLoading = false }
            guard shop.total > 0 else {
                delegate?.presentAlert(
                    title: "검색 결과가 없어요.",
                    message: nil,
                    action: nil
                )
                return .none
            }
            delegate?.pushShopList(query: query, shop: shop)
            return .none
        case let .bindErrorMessage(message):
            delegate?.presentAlert(
                title: "오류",
                message: message,
                action: { [weak self] in
                    self?.errorMessage = nil
                }
            )
            state.isLoading = false
            return .none
        }
    }
}
