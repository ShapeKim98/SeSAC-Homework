//
//  Composable.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol Composable {
    associatedtype Action
    associatedtype State
    
    var observableState: Driver<State> { get }
    var send: PublishRelay<Action> { get }
}
