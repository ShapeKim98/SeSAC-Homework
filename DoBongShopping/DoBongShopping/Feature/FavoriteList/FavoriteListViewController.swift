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
    private let searchController = UISearchController()
    private lazy var collectionViewController = ShopCollectionViewController(
        viewModel: viewModel.shopCollectionViewModel
    )
    
    private let viewModel = FavoriteListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureCollectionViewController()
        
        configureLayout()
        
        bindAction()
        
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
        
        configureSearchController()
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
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "제목 또는 판매처"
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.overrideUserInterfaceStyle = .dark
        searchController.searchBar.overrideUserInterfaceStyle = .dark
        searchController.searchBar.searchTextField.overrideUserInterfaceStyle = .dark
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: Bindings
private extension FavoriteListViewController {
    typealias Action = FavoriteListViewModel.Action
    
    func bindAction() {
        searchController.searchBar.searchTextField.rx.text.orEmpty
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .map { Action.searchTestFieldTextOnChanged($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
}
