//
//  Effect.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift
import RxCocoa

extension Observable {
    static func send<Action>(_ action: Action) -> Observable<Effect<Action>> {
        return .create { observer in
            observer.onNext(.send(action))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

enum Effect<Action> {
    case send(Action)
    
    var action: Action {
        switch self {
        case .send(let action):
            return action
        }
    }
}
