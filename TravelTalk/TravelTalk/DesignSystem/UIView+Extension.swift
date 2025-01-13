//
//  UIView+Extension.swift
//  TravelTalk
//
//  Created by 김도형 on 1/11/25.
//

import UIKit

public extension UIView {
    func ttBubbleStyle(color: UIColor) {
        self.backgroundColor = color
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
