//
//  UserDefault.swift
//  EmotionDiary
//
//  Created by 김도형 on 12/31/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    
    init(forKey: String, defaultValue: T? = nil) {
        self.key = forKey
        self.defaultValue = defaultValue
        if self.defaultValue == nil {
            UserDefaults.standard.set(defaultValue, forKey: key)
        }
    }
    
    var wrappedValue: T? {
        get { (UserDefaults.standard.object(forKey: key) as? T) ?? defaultValue }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

enum UserDefaultKey: String {
    case captain = "Captain"
    case rice = "Rice"
    case waterDrop = "WaterDrop"
    case level = "Level"
}

extension String {
    static func userDefault(_ key: UserDefaultKey) -> String {
        key.rawValue
    }
}
