//
//  UILabel+Extension.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

public extension UILabel {
    func ttDateStyle() {
        self.font = .systemFont(ofSize: 12)
        self.textColor = .secondaryLabel
    }
    
    func ttMessageStyle() {
        self.font = .systemFont(ofSize: 14)
        self.numberOfLines = 0
    }
}
