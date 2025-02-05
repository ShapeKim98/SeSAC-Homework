//
//  Observable.swift
//  MVVMProject
//
//  Created by 김도형 on 2/5/25.
//

import Foundation

@propertyWrapper
class Modelable<T> {
    var value: T {
        didSet { closure?(oldValue, value) }
    }
    
    var closure: ((T, T) -> Void)?
    
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (_ oldValue: T, _ newValue: T) -> Void) {
        self.closure = closure
    }
}
