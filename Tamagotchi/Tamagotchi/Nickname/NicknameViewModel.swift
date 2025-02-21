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
        send.withUnretained(self)
            .map { this, action in this.reducer(action) }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    func reducer(_ action: Action) -> State {
        var newState = state.value
        
        switch action {
        case let .captainTextFieldTextOnChanged(text):
            newState.isValidText = 2 <= text.count && text.count <= 6
            return newState
        case let .saveButtonTapped(text):
            newState.captain = text
            return newState
        }
    }
}
