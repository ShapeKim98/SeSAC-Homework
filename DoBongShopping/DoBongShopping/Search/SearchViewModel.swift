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
    func presentAlert(title: String?, message: String?)
}

@MainActor
final class SearchViewModel {
    enum Action {
        case searchBarSearchButtonClicked(_ text: String)
        case bindShop(String, ShopResponse)
    }
    
    struct State {
        var isLoading: Bool = false
    }
    
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
                delegate?.presentAlert(title: "두 글자 이상 입력해주세요.", message: nil)
                return .none
            }
            guard !query.filter(\.isLetter).isEmpty else {
                delegate?.presentAlert(title: "글자를 포함해주세요.", message: nil)
                return .none
            }
            state.isLoading = true
            return .run { effect in
                let request = ShopRequest(query: query)
                let shop = try await ShopClient.shared.fetchShop(request)
                effect.onNext(.send(.bindShop(query, shop)))
            } catch: { error in
                print((error as? AFError) ?? error)
                return .none
            }
        case let .bindShop(query, shop):
            guard shop.total > 0 else {
                delegate?.presentAlert(title: "검색 결과가 없어요.", message: nil)
                return .none
            }
            state.isLoading = false
            delegate?.pushShopList(query: query, shop: shop)
            return .none
        }
    }
}
