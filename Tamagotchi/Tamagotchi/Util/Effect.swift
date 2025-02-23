//
//  Effect.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift

protocol EffectProtocol {
    associatedtype Action
    static func send(_ action: Action) -> Self
}

enum Effect<Action>: EffectProtocol {
    case send(Action)
    
    var action: Action {
        switch self {
        case .send(let action):
            return action
        }
    }
}

extension Observable where Element: EffectProtocol {
    static func send(_ action: Element.Action) -> Observable<Element> {
        return .create { observer in
            observer.onNext(.send(action))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    static func run(
        _ observable: Observable<Element.Action>
    ) -> Observable<Element> {
        return observable.map { Element.send($0) }
    }
    
    static func merge(
        _ observables: Observable<Element.Action>...
    ) -> Observable<Element> {
        let creates = observables.map { observable in
            observable
                .map { Element.send($0) }
        }
        return .merge(creates)
    }
}
