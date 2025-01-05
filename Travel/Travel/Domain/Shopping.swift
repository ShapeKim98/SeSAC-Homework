//
//  Shopping.swift
//  Travel
//
//  Created by 김도형 on 1/5/25.
//

import Foundation

public struct Shopping {
    public let title: String
    public var isBought: Bool
    public var isFavorite: Bool
    
    public init(
        title: String,
        isBought: Bool = false,
        isFavorite: Bool = false
    ) {
        self.title = title
        self.isBought = isBought
        self.isFavorite = isFavorite
    }
}

public extension Shopping {
    static let defaultList: [Shopping] = [
        Shopping(title: "그립톡 구해하기", isBought: true, isFavorite: true),
        Shopping(title: "사이다 구매", isBought: false, isFavorite: false),
        Shopping(title: "아이패드 케이스 최저가 알아보기", isBought: false, isFavorite: true),
        Shopping(title: "양말", isBought: false, isFavorite: true)
    ]
}
