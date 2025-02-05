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
        case amount(oldValue: String, newValue: String)
    }
    
    class Model {
        var amount: String = "" {
            didSet {
                output?(.amount(oldValue: oldValue, newValue: amount))
            }
        }
        
        var output: ((Output) -> Void)?
    }
    
    private(set) var model = Model()
    
    func output(_ bind: @escaping (Output) -> Void) {
        self.model.output = bind
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
