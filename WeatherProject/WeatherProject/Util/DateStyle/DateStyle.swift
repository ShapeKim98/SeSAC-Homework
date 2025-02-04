//
//  DateStyle.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import Foundation

enum DateStyle: String, CaseIterable {
    case yyyy년_M월_d일
    
    var style: Date.FormatStyle {
        switch self {
        case .yyyy년_M월_d일:
            return Date.FormatStyle()
                .month(.defaultDigits)
                .day(.defaultDigits)
                .year(.defaultDigits)
                .hour(.twoDigits(amPM: .abbreviated))
                .minute(.twoDigits)
                .locale(Locale(identifier: "ko_KR"))
        }
    }
}

extension Date {
    func toString(format: DateStyle) -> String {
        return self.formatted(format.style)
    }
}

extension String {
    func date(format: DateStyle) -> Date? {
        return try? Date(self, strategy: format.style)
    }
}
