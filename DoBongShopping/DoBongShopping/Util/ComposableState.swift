//
//  ComposableState.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/1/25.
//

import Foundation

import RxSwift
import RxCocoa

@propertyWrapper
final class ComposableState<State> {
    private let relay: BehaviorRelay<State>
    
    init(wrappedValue: State) {
        relay = BehaviorRelay(value: wrappedValue)
    }
    
    var wrappedValue: State {
        get { relay.value }
        set { relay.accept(newValue) }
    }
    
    var projectedValue: Driver<State> {
        relay.asDriver()
    }
}
