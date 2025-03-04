//
//  FavoriteListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class FavoriteListViewController: UIViewController {
    private lazy var collectionViewController = ShopCollectionViewController(
        viewModel: viewModel.shopCollectionViewModel
    )
    
    private let viewModel = FavoriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureCollectionViewController()
        
        configureLayout()
        
        viewModel.send.accept(.viewDidLoad)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        collectionViewController.willMove(toParent: nil)
        collectionViewController.view.removeFromSuperview()
        collectionViewController.removeFromParent()
    }
}

// MARK: Configure Views
private extension FavoriteListViewController {
    func configureUI() {
        view.backgroundColor = .black
        
        configureNavigation()
    }
    
    func configureLayout() {
        collectionViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionViewController() {
        view.addSubview(collectionViewController.view)
        
        addChild(collectionViewController)
        
        collectionViewController.didMove(toParent: self)
    }
    
    func configureNavigation() {
        navigationController?
            .navigationBar
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "좋아요 목록"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}
