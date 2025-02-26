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
    
    func pushSFSafariViewController(animated: Bool) -> Binder<SFSafariViewController> {
        Binder(base) { base, safariViewController in
            base.navigationController?.present(safariViewController, animated: animated)
            base.navigationController?.setNavigationBarHidden(true, animated: false)
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
