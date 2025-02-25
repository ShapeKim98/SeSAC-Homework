//
//  AppCoordinator.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import UIKit
import SafariServices

@MainActor
final class AppCoordinator: NSObject {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        viewModel.delegate = self
        navigationController.setViewControllers(
            [SearchViewController(viewModel: viewModel)],
            animated: true
        )
    }
    
    private func pushShopListViewController(query: String, shop: ShopResponse) {
        let viewModel = ShopListViewModel(query: query, shop: shop)
        viewModel.delegate = self
        let viewController = ShopListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushSFSafariViewController(url: URL) {
        navigationController.setNavigationBarHidden(true, animated: false)
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.overrideUserInterfaceStyle = .dark
        safariViewController.delegate = self
        navigationController.present(safariViewController, animated: true)
    }
    
    private func presentNavigationAlert(
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
        navigationController.present(alert, animated: true)
    }
}

extension AppCoordinator: SearchViewModelDelegate {
    func pushShopList(query: String, shop: ShopResponse) {
        pushShopListViewController(query: query, shop: shop)
    }
    
    func presentAlert(title: String?, message: String?, action: (() -> Void)?) {
        presentNavigationAlert(
            title: title,
            message: message,
            action: { _ in action?() }
        )
    }
}

extension AppCoordinator: ShopListViewModelDelegate {
    func presentAlertFromShopList(title: String?, message: String?, action: (() -> Void)?) {
        presentNavigationAlert(
            title: title,
            message: message,
            action: { _ in action?() }
        )
    }
    
    func pushSafariViewController(url: URL) {
        pushSFSafariViewController(url: url)
    }
}

extension AppCoordinator: @preconcurrency SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        navigationController.setNavigationBarHidden(false, animated: false)
    }
}


#Preview {
    let viewController = UINavigationController()
    let coordinator = AppCoordinator(navigationController: viewController)
    coordinator.start()
    
    return viewController
}
