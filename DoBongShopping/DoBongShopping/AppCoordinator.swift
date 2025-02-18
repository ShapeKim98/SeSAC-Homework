//
//  AppCoordinator.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import UIKit

@MainActor
final class AppCoordinator {
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
        let viewModel = SearchListViewModel(shop: shop)
        let viewController = ShopListViewController(query: query, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func presentNavigationAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        navigationController.present(alert, animated: true)
    }
}

extension AppCoordinator: SearchViewModelDelegate {
    func pushShopList(query: String, shop: ShopResponse) {
        pushShopListViewController(query: query, shop: shop)
    }
    
    func presentAlert(title: String?, message: String?) {
        presentNavigationAlert(title: title)
    }
}

#Preview {
    let viewController = UINavigationController()
    let coordinator = AppCoordinator(navigationController: viewController)
    coordinator.start()
    
    return viewController
}
