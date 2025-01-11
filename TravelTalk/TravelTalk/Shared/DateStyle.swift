//
//  DateStyle.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import Foundation

public enum DateStyle: String, CaseIterable {
    case chatRaw = "yyyy-MM-dd HH:mm"
    case chat = "yy.MM.dd"
    case message = "hh:mm a"
    
    public static var cachedDateFormatter: [DateStyle: DateFormatter] {
        var cachedFormatter = [DateStyle: DateFormatter]()
        
        for style in Self.allCases {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = style.rawValue
            cachedFormatter[style] = formatter
        }
        
        return cachedFormatter
    }
}

public extension DateFormatter {
    static let cachedFormatters = DateStyle.cachedDateFormatter
    
    static func cachedFormatter(_ style: DateStyle) -> DateFormatter {
        return cachedFormatters[style] ?? DateFormatter()
    }
}
