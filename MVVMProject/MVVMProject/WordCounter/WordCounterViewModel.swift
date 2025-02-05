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
        case countLabelText(oldValue: String, newValue: String)
    }
    
    struct Model {
        var countLabelText: String = "" {
            didSet {
                output?(.countLabelText(oldValue: oldValue, newValue: countLabelText))
            }
        }
        
        var output: ((Output) -> Void)?
    }
    
    private var model = Model()
    
    func output(_ bind: @escaping (Output) -> Void) {
        self.model.output = bind
    }
    
    func input(_ action: Input) {
        switch action {
        case let .textViewDidChange(text):
            model.countLabelText = "현재까지 \(text.count)글자 작성중"
            return
        }
    }
}
