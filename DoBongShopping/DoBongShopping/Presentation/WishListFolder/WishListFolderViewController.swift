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

final class WishListFolderViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, WishFolder>
    typealias Registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishFolder>
    
    private lazy var collectionView = { configureCollectionView() }()
    private let searchController = UISearchController()
    
    private lazy var dataSource = { configureDataSource() }()
    
    private let viewModel = WishListFolderViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
         
        bindAction()
        
        viewModel.send.accept(.viewDidLoad)
    }
}

// MARK: Configure Views
private extension WishListFolderViewController {
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
            let count = itemIdentifier.items.count
            content.secondaryText = "\(count) 개"
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
        searchController.searchBar.placeholder = "생성할 폴더 이름을 입력해주세요."
        searchController.searchBar.overrideUserInterfaceStyle = .dark
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
    }
}

// MARK: Bindings
private extension WishListFolderViewController {
    typealias Action = WishListFolderViewModel.Action
    
    func bindAction() {
        let searchButtonClicked = searchController.searchBar.rx.searchButtonClicked.share()
        
        searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .map { Action.searchButtonClicked($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        searchButtonClicked
            .map { "" }
            .bind(to: searchController.searchBar.rx.text)
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
        viewModel.$state.driver
            .map(\.wishList)
            .distinctUntilChanged()
            .drive(with: self) { this, wishListFolder in
                var snapshot = NSDiffableDataSourceSnapshot<String, WishFolder>()
                snapshot.appendSections([.wishListFolder])
                snapshot.appendItems(wishListFolder, toSection: .wishListFolder)
                this.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        viewModel.$state.present(\.$selectedFolder)
            .compactMap(\.self)
            .map { folder in
                let viewModel = WishListViewModel(wishFolder: folder)
                return WishListViewController(viewModel: viewModel)
            }
            .drive(rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
}

fileprivate extension String {
    static let wishListFolder = "WishListFolder"
}

//#Preview {
//    UINavigationController(rootViewController: WishListViewController())
//}
