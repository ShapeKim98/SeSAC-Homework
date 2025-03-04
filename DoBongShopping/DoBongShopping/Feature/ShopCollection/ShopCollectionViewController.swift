//
//  ShopCollectionViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ShopCollectionViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        configureCollectionView()
    }()
    
    private let viewModel: ShopCollectionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ShopCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
        
        bindAction()
    }
    
    func scrollToTop() {
        collectionView.scrollToItem(
            at: IndexPath(item: 0, section: 0),
            at: .top,
            animated: true
        )
    }
}

// MARK: Configure Views
private extension ShopCollectionViewController {
    func configureUI() {
        view.backgroundColor = .clear
    }
    
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        let width = (view.frame.width - (2 + 1) * 12) / 2
        layout.itemSize = CGSize(width: width, height: 300)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: .shopCollectionCell
        )
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        return collectionView
    }
}

// MARK: Bindings
private extension ShopCollectionViewController {
    typealias Action = ShopCollectionViewModel.Action
    
    func bindAction() {
        collectionView.rx.willDisplayCell
            .map(\.at.item)
            .map { Action.collectionViewWillDisplay(item: $0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .map { Action.collectionViewPrefetchItemsAt(items: $0.map(\.item)) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        collectionView.rx.didEndDisplayingCell
            .compactMap { cell, _ in cell as? ShopCollectionViewCell }
            .bind { $0.cancelImageDownload() }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ShopResponse.Item.self)
            .map { Action.collectionViewModelSelected($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindShop()
        
        bindSelectedItem()
    }
    
    func bindShop() {
        viewModel.$state.driver
            .map(\.shopItems)
            .distinctUntilChanged()
            .drive(collectionView.rx.items(
                cellIdentifier: .shopCollectionCell,
                cellType: ShopCollectionViewCell.self
            )) { indexPath, item, cell in
                cell.cellForItemAt(item)
            }
            .disposed(by: disposeBag)
    }
    
    func bindSelectedItem() {
        viewModel.$state.present(\.$selectedItem)
            .compactMap(\.self)
            .map { WebViewController(viewModel: WebViewModel(item: $0)) }
            .drive(rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
}
