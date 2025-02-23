//
//  UserDefault.swift
//  EmotionDiary
//
//  Created by 김도형 on 12/31/24.
//

import Foundation

import RxSwift
import RxCocoa

@propertyWrapper
struct Shared<T> {
    private let type: SharedType<T>
    
    init(_ type: SharedType<T>) {
        self.type = type
    }
    
    var wrappedValue: T? {
        get {
            switch type {
            case let .userDefaults(key, defaultValue):
                (UserDefaults.standard.object(forKey: key.rawValue) as? T) ?? defaultValue
            }
        }
        set {
            switch type {
            case let .userDefaults(key, _):
                if newValue == nil {
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                } else {
                    UserDefaults.standard.set(newValue, forKey: key.rawValue)
                }
            }
        }
    }
    
    var projectedValue: Observable<T?> {
        switch type {
        case let .userDefaults(key, _):
            UserDefaults.standard.rx
                .observe(T.self, key.rawValue, options: [.initial, .new])
        }
    }
}

enum SharedType<T> {
    case userDefaults(UserDefaultKey, defaultValue: T? = nil)
}

enum UserDefaultKey: String {
    case captain = "Captain"
    case rice = "Rice"
    case waterDrop = "WaterDrop"
    case level = "Level"
}
