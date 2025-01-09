//
//  Button+Extension.swift
//  UpDownGame
//
//  Created by 김도형 on 1/9/25.
//

import UIKit

public extension UIButton {
    func setUDButtonStyle(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.configuration?.cornerStyle = .fixed
        self.backgroundColor = .black
    }
}
