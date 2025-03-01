//
//  WishListViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class WishListViewModel: Composable {
    enum Action {
        case searchButtonClicked(String)
        case collectionViewItemSelected(Int)
    }
    
    struct State {
        var wishList: [Wish] = []
    }
    
    let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init() {
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case let .searchButtonClicked(text):
            let with = Wish(name: text)
            state.wishList.append(with)
            return .none
        case let .collectionViewItemSelected(index):
            state.wishList.remove(at: index)
            return .none
        }
    }
}
