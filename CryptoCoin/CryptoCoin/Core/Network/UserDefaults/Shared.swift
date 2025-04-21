//
//  Shared.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/21/25.
//

import Foundation
import Combine

@propertyWrapper
struct Shared<T> {
    private let type: SharedType<T>
    private let subject = PassthroughSubject<T?, Never>()
    
    init(_ type: SharedType<T>) {
        self.type = type
    }
    
    init(wrappedValue: T, _ type: SharedType<T>) {
        self.type = type
        
        switch type {
        case .userDefaults(let key):
            if UserDefaults.standard.object(forKey: key.rawValue) == nil {
                UserDefaults.standard.set(wrappedValue, forKey: key.rawValue)
            }
        }
    }
    
    var wrappedValue: T? {
        get {
            switch type {
            case let .userDefaults(key):
                UserDefaults.standard.object(forKey: key.rawValue) as? T
            }
        }
        set {
            switch type {
            case let .userDefaults(key):
                UserDefaults.standard.set(newValue, forKey: key.rawValue)
                subject.send(newValue)
            }
        }
    }
    
    var projectedValue: AnyPublisher<T, Never> {
        switch type {
        case .userDefaults(let key):
            subject.compactMap(\.self)
                .eraseToAnyPublisher()
        }
    }
}

enum SharedType<T> {
    case userDefaults(UserDefaultKey)
}

enum UserDefaultKey: String {
    case favoriteIds
}
