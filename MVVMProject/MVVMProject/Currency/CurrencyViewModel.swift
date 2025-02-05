//
//  CurrencyViewModel.swift
//  MVVMProject
//
//  Created by 김도형 on 2/5/25.
//

import Foundation

class CurrencyViewModel {
    enum Input {
        case convertButtonTapped(String?)
    }
    
    enum Output {
        case amount(_ value: String)
    }
    
    struct Model {
        var amount: String = "" {
            didSet {
                guard oldValue != amount else { return }
                continuation?.yield(.amount(amount))
            }
        }
        
        var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model = Model()
    
    var output: AsyncStream<Output> {
        return AsyncStream<Output> { continuation in
            model.continuation = continuation
        }
    }
    
    deinit {
        model.continuation?.finish()
    }
    
    func input(_ action: Input) {
        switch action {
        case let .convertButtonTapped(text):
            guard let text, let amount = Double(text) else {
                model.amount = "올바른 금액을 입력해주세요"
                return
            }
            let exchangeRate = 1446.0 // 실제 환율 데이터로 대체 필요
            let convertedAmount = amount / exchangeRate
            model.amount = String(
                format: "%.2f USD (약 $%.2f)",
                convertedAmount,
                convertedAmount
            )
            return
        }
    }
}
