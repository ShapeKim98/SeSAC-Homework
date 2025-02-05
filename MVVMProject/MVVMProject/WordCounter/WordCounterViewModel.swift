//
//  WordCounterViewModel.swift
//  MVVMProject
//
//  Created by 김도형 on 2/5/25.
//

import Foundation

class WordCounterViewModel {
    enum Input {
        case textViewDidChange(String)
    }
    
    enum Output {
        case countLabelText(_ value: String)
    }
    
    struct Model {
        var countLabelText: String = "" {
            didSet {
                guard oldValue != countLabelText else { return }
                continuation?.yield(.countLabelText(countLabelText))
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
        case let .textViewDidChange(text):
            model.countLabelText = "현재까지 \(text.count)글자 작성중"
            return
        }
    }
}
