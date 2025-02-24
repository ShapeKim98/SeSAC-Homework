//
//  Effect.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/21/25.
//

import Foundation

import RxSwift

enum Effect<Action> {
    case send(Action)
    case run(Observable<Action>, `catch`: ((Error) -> Self)? = nil)
    case merge([Self])
    case concatenate([Self])
    case none
    
    static func run(
        _ single: Single<Action>,
        catch: ((Error) -> Self)? = nil
    ) -> Effect {
        return .run(single.asObservable(), catch: `catch`)
    }
    
    static func merge(_ effects: Self...) -> Effect {
        return .merge(effects)
    }
    
    static func concatenate(_ effects: Self...) -> Effect {
        return .concatenate(effects)
    }
    
    var observable: Observable<Self> {
        switch self {
        case let .send(action):
            return .create { observer in
                observer.onNext(.send(action))
                observer.onCompleted()
                return Disposables.create()
            }
        case let .run(observable, `catch`):
            return observable
                .map { Effect.send($0) }
                .catch { .just(`catch`?($0) ?? .none) }
        case let .merge(effects):
            return .merge(effects.map(\.observable))
        case let .concatenate(effects):
            return .concat(effects.map(\.observable))
        case .none:
            return .create { observer in
                observer.onNext(.none)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
    
    var action: Action? {
        switch self {
        case .send(let action):
            return action
        case .merge: return nil
        case .concatenate: return nil
        case .run: return nil
        case .none: return nil
        }
    }
}
