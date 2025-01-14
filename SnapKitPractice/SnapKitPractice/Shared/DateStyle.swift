//
//  DateStyle.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public enum DateStyle {
    case yyyy_MM_dd
    case yyyyMMdd
    
    public var strategy: Date.ParseStrategy {
        switch self {
        case .yyyy_MM_dd:
            return Date.ParseStrategy(
                format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
                timeZone: .autoupdatingCurrent
            )
        case .yyyyMMdd:
            return Date.ParseStrategy(
                format: "\(year: .defaultDigits)\(month: .twoDigits)\(day: .twoDigits)",
                timeZone: .autoupdatingCurrent
            )
        }
    }
}

public extension String {
    func date(format: DateStyle) -> Date? {
        return try? Date(self, strategy: format.strategy)
    }
}
