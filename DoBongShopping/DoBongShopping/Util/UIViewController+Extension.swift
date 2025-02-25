//
//  UIViewController+Extension.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/25/25.
//

import UIKit

extension UIViewController {
    func presentAlert(
        title: String?,
        message: String? = nil,
        action: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default,
            handler: { action?($0) }
        )
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
