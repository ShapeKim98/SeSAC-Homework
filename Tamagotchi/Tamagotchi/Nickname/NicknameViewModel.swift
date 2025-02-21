//
//  NicknameViewModel.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameViewModel {
    enum Action {
        case captainTextFieldTextOnChanged(String)
        case saveButtonTapped(String)
    }
    
    struct State {
        @Shared(.userDefaults(.captain, defaultValue: "대장"))
        var captain: String?
        var isValidText: Bool = false
    }
    
    private var state = BehaviorRelay(value: State())
    var observableState: Driver<State> {
        state.asDriver()
    }
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init() {
        send
            .observe(on: SerialDispatchQueueScheduler(qos: .default))
            .withUnretained(self)
            .map { this, action in
                var state = this.state.value
                this.reducer(&state, action)?
                    .compactMap { $0.action }
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>>? {
        switch action {
        case let .captainTextFieldTextOnChanged(text):
            state.isValidText = 2 <= text.count && text.count <= 6
            return .none
        case let .saveButtonTapped(text):
            state.captain = text
            return .none
        }
    }
}
