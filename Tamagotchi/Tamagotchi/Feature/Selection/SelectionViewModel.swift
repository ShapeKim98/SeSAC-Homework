//
//  SelectionViewModel.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SelectionViewModel: Composable {
    enum Action {
        case collectionViewModelSelected(Tamagotchi)
    }
    
    struct State {
        var tamagotchiList = Tamagotchi.allCases + Array(repeating: .준비중, count: 30)
        var selectedTamagotchi: Tamagotchi?
    }
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    init() {
        send
            .observe(on: MainScheduler.asyncInstance)
            .debug()
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state.value
                this.reducer(&state, action)?
                    .compactMap(\.action)
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>>? {
        return .none
    }
}
