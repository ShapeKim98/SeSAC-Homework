//
//  Effect.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift
import RxCocoa

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
        _ observable: Observable<Element.Action>,
        disposeBag: DisposeBag
    ) -> Observable<Element> {
        return .create { observer in
            observable
                .map { Element.send($0) }
                .bind(to: observer)
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    static func merge(
        _ observables: Observable<Element.Action>...,
        disposeBag: DisposeBag
    ) -> Observable<Element> {
        let creates = observables.map { observable in
            return Observable.create { observer in
                observable
                    .map { Element.send($0) }
                    .bind(to: observer)
                    .disposed(by: disposeBag)
                
                return Disposables.create()
            }
        }
        return .merge(creates)
    }
}
