//
//  UIView+Extension.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/14/25.
//

import UIKit

public extension UIView {
    @discardableResult
    func border(radius: CGFloat, color: UIColor, width: CGFloat) -> UIView {
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
        
        return self
    }
}
