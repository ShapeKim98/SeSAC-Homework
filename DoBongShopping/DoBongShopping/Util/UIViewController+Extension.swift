//
//  UIViewController+Extension.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import UIKit
import SafariServices

import RxSwift
import RxCocoa

@MainActor
extension Reactive where Base: UIViewController {
    func pushViewController(animated: Bool) -> Binder<UIViewController> {
        Binder(base) { base, viewController in
            base.navigationController?.pushViewController(
                viewController,
                animated: animated
            )
        }
    }
    
    func presentAlert(title: String?, actions: UIAlertAction...) -> Binder<String?> {
        Binder(base) { base, message in
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            for action in actions {
                alert.addAction(action)
            }
            base.present(alert, animated: true)
        }
    }
}
