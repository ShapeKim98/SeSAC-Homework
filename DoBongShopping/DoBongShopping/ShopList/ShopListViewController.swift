//
//  ShopListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit
import SafariServices

import SnapKit
import Alamofire
import RxSwift
import RxCocoa

final class ShopListViewController: UIViewController {
    private let totalLabel = UILabel()
    private let sortButtonHStack = UIStackView()
    private var sortButtons = [SortButton]()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private lazy var collectionView: UICollectionView = {
        configureCollectionView()
    }()
    
    private let viewModel: ShopListViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ShopListViewModel) {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.send.accept(.safariViewControllerDidFinish)
    }

}

// MARK: Configure Views
private extension ShopListViewController {
    func configureUI() {
        view.backgroundColor = .black
        
        configureNavigation()
        
        configureTotalLabel()
        
        configureSortButtonHStack()
        
        configureSortButtons()
        
        configureIndicatorView()
    }
    
    func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        sortButtonHStack.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonHStack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
        }
    }
    
    func configureNavigation() {
        navigationController?
            .navigationBar
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureTotalLabel() {
        totalLabel.textColor = .systemGreen
        totalLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(totalLabel)
    }
    
    func configureSortButtonHStack() {
        sortButtonHStack.axis = .horizontal
        sortButtonHStack.distribution = .fill
        sortButtonHStack.spacing = 8
        view.addSubview(sortButtonHStack)
    }
    
    func configureSortButtons() {
        for sort in Sort.allCases {
            let button = SortButton(title: sort.title)
            sortButtons.append(button)
            sortButtonHStack.addArrangedSubview(button)
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
    
    func configureIndicatorView() {
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        indicatorView.color = .white
        view.addSubview(indicatorView)
    }
}

// MARK: Data Bindings
private extension ShopListViewController {
    typealias Action = ShopListViewModel.Action
    
    func bindAction() {
        for (index, sort) in Sort.allCases.enumerated() {
            let button = sortButtons[index]
            button.rx.tap
                .map { Action.sortButtonTouchUpInside(sort: sort) }
                .bind(to: viewModel.send)
                .disposed(by: disposeBag)
        }
        
        collectionView.rx.willDisplayCell
            .map { cell, indexPath in
                Action.collectionViewWillDisplay(item: indexPath.item)
            }
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
        
        bindSelectedSort()
        
        bindIsLoading()
        
        bindQuery()
        
        bindURL()
    }
    
    func bindShop() {
        viewModel.observableState
            .map(\.shop.items)
            .distinctUntilChanged()
            .drive(collectionView.rx.items(
                cellIdentifier: .shopCollectionCell,
                cellType: ShopCollectionViewCell.self
            )) { indexPath, item, cell in
                cell.cellForItemAt(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.observableState
            .map(\.shop.total)
            .distinctUntilChanged()
            .map { "\($0.formatted())개의 검색 결과" }
            .drive(totalLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindSelectedSort() {
        viewModel.observableState
            .map(\.selectedSort)
            .distinctUntilChanged()
            .drive(with: self) { this, selectedSort in
                this.collectionView.scrollToItem(
                    at: IndexPath(item: 0, section: 0),
                    at: .top,
                    animated: true
                )
                UIView.animate(withDuration: 0.3) {
                    for (index, sort) in Sort.allCases.enumerated() {
                        let isSelected = sort == selectedSort
                        this.sortButtons[index].isSelected(isSelected)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindIsLoading() {
        viewModel.observableState
            .map(\.isLoading)
            .distinctUntilChanged()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func bindQuery() {
        viewModel.observableState
            .map(\.query)
            .distinctUntilChanged()
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    func bindURL() {
        viewModel.observableState
            .compactMap(\.selectedItem)
            .map { WebViewController(viewModel: WebViewModel(item: $0)) }
            .drive(rx.pushViewController(animated: true))
            .disposed(by: disposeBag)
    }
    
    func bindErrorMessage() {
        let action =  UIAlertAction(
            title: "확인",
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.send.accept(.errorAlertTapped)
            }
        )
        
        viewModel.observableState
            .compactMap(\.errorMessage)
            .drive(rx.presentAlert(title: "오류", actions: action))
            .disposed(by: disposeBag)
    }
}

extension ShopListViewController {
    final class SortButton: UIButton {
        init(title: String) {
            super.init(frame: .zero)
            
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            backgroundColor = .clear
            layer.cornerRadius = 8
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            
            titleLabel?.textAlignment = .center
            titleLabel?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func isSelected(_ selected: Bool) {
            backgroundColor = selected ? .white : .clear
            setTitleColor(selected ? .black : .white, for: .normal)
        }
    }
}

enum Sort: String, CaseIterable {
    case sim = "sim"
    case date = "date"
    case dsc = "dsc"
    case asc = "asc"
    
    var title: String {
        switch self {
        case .sim: return "정확도"
        case .date: return "날짜순"
        case .dsc: return "가격높은순"
        case .asc: return "가격낮은순"
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ShopListViewController(viewModel: ShopListViewModel(query: "캠핑카", shop: .mock)))
}
