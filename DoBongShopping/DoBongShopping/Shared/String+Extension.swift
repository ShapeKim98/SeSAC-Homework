//
//  String+Extension.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public extension String {
    func removeHTMLTags() -> String {
        self.replacingOccurrences(
            of: "<[^>]+>|&quot;",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }
}
