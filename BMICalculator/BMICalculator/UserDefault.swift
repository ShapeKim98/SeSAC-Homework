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
    
    init(forKey: String) {
        self.key = forKey
    }
    
    var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: key) as? T }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

extension String {
    static let tall = "Tall"
    static let weight = "Weight"
    static let nickname = "Nickname"
}
