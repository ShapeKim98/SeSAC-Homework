//
//  DateStyle.swift
//  Travel
//
//  Created by 김도형 on 1/6/25.
//

import Foundation

public enum DateStyle: String, CaseIterable {
    case numberOnly = "yyMMdd"
    case numberAndString = "yy년 MM월 dd일"
    
    public static var cachedDateFormatter: [DateStyle: DateFormatter] {
        var cachedFormatter = [DateStyle: DateFormatter]()
        
        for style in Self.allCases {
            let formatter = DateFormatter()
            formatter.dateFormat = style.rawValue
            cachedFormatter[style] = formatter
        }
        
        return cachedFormatter
    }
}
