//
//  WishListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class WishListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, Wish>
    typealias Registration = UICollectionView.CellRegistration<UICollectionViewListCell, Wish>
    
    private lazy var collectionView = { configureCollectionView() }()
    private let searchController = UISearchController()
    
    private lazy var dataSource = { configureDataSource() }()
    
    private let viewModel = WishListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
         
        bindAction()
    }
}

// MARK: Configure Views
private extension WishListViewController {
    func configureUI() {
        view.backgroundColor = .black
        
        configureSearchController()
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        var separatorConfiguration = UIListSeparatorConfiguration(listAppearance: .plain)
        separatorConfiguration.color = .white
        configuration.separatorConfiguration = separatorConfiguration
        configuration.backgroundColor = .black
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        return collectionView
    }
    
    func configureDataSource() -> DataSource {
        let registration = Registration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.textProperties.color = .white
            let date = itemIdentifier.date
            content.secondaryText = "\(date.formatted(.dateTime.year())) - \(date.formatted(.dateTime.month(.defaultDigits))) - \(date.formatted(.dateTime.day()))"
            cell.contentConfiguration = content
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.backgroundColor = .black
            cell.backgroundConfiguration = backgroundConfiguration
            cell.overrideUserInterfaceStyle = .dark
        }
        
        return DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath, item: itemIdentifier
                )
                return cell
            }
        )
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "관심 상품을 입력해주세요"
        searchController.searchBar.overrideUserInterfaceStyle = .dark
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

// MARK: Bindings
private extension WishListViewController {
    typealias Action = WishListViewModel.Action
    
    func bindAction() {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .map { Action.searchButtonClicked($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { Action.collectionViewItemSelected($0.item) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindWishList()
    }
    
    func bindWishList() {
        viewModel.$state
            .map(\.wishList)
            .distinctUntilChanged()
            .drive(with: self) { this, wishList in
                var snapshot = NSDiffableDataSourceSnapshot<String, Wish>()
                snapshot.appendSections([.wishList])
                snapshot.appendItems(wishList, toSection: .wishList)
                this.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
}

fileprivate extension String {
    static let wishList = "WishList"
}

#Preview {
    UINavigationController(rootViewController: WishListViewController())
}
