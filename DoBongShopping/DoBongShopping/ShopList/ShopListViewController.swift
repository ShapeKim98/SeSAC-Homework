//
//  ShopListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit
import Alamofire

final class ShopListViewController: UIViewController {
    private let totalLabel = UILabel()
    private let sortButtonHStack = UIStackView()
    private var sortButtons = [SortButton]()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private lazy var collectionView: UICollectionView = {
        configureCollectionView()
    }()
    
    private let viewModel: SearchListViewModel
    
    private let query: String
    
    init(
        query: String,
        shop: ShopResponse = .mock,
        viewModel: SearchListViewModel
    ) {
        self.query = query
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
        
        bind()
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
        navigationItem.title = query
        navigationController?
            .navigationBar
            .titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?
            .navigationBar
            .topItem?
            .title = ""
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureTotalLabel() {
        totalLabel.text = "\(viewModel.model.shop.total.formatted())개의 검색 결과"
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
            button.isSelected(sort == viewModel.model.selectedSort)
            button.addAction(
                UIAction { [weak self] _ in
                    guard let `self` else { return }
                    self.sortButtonTouchUpInside(sort: sort)
                },
                for: .touchUpInside
            )
            sortButtons.append(button)
            sortButtonHStack.addArrangedSubview(button)
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        let collectionView = VerticalCollectionView(
            superSize: view.frame,
            itemHeight: 300,
            colCount: 2,
            colSpacing: 12,
            rowSpacing: 16,
            inset: UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: .shopCollectionCell
        )
        view.addSubview(collectionView)
        
        return collectionView
    }
    
    func configureIndicatorView() {
        indicatorView.stopAnimating()
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .white
        view.addSubview(indicatorView)
    }
}

// MARK: Data Bindings
private extension ShopListViewController {
    func bind() {
        Task { [weak self] in
            guard let self else { return }
            for await output in viewModel.output {
                switch output {
                case .shopItems:
                    bindedShop()
                case let .selectedSort(sort):
                    bindedSelectedSort(sort)
                case let .isLoading(isLoading):
                    bindedIsLoading(isLoading)
                }
            }
        }
    }
    
    func bindedShop() {
        print(#function)
        collectionView.reloadData()
    }
    
    func bindedSelectedSort(_ sort: Sort) {
        print(#function)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let `self` else { return }
            for (index, sort) in Sort.allCases.enumerated() {
                let isSelected = sort == viewModel.model.selectedSort
                sortButtons[index].isSelected(isSelected)
            }
        }
    }
    
    func bindedIsLoading(_ isLoading: Bool) {
        print(#function)
        if isLoading {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
}

// MARK: Functions
private extension ShopListViewController {
    func sortButtonTouchUpInside(sort: Sort) {
        collectionView.scrollToItem(
            at: IndexPath(item: 0, section: 0),
            at: .top,
            animated: true
        )
        viewModel.input(.sortButtonTouchUpInside(query: query, sort: sort))
    }
}

extension ShopListViewController: UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.shop.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .shopCollectionCell,
            for: indexPath
        ) as? ShopCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        
        cell.cellForItemAt(viewModel.model.shop.items[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.input(.collectionViewWillDisplay(query: query, item: indexPath.item))
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard
                indexPath.item + 2 == viewModel.model.shop.items.count
            else { continue }
            viewModel.input(.collectionViewPrefetchItemsAt(query: query))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let shopCell = cell as? ShopCollectionViewCell
        shopCell?.cancelImageDownload()
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
    UINavigationController(rootViewController: ShopListViewController(query: "캠핑카", viewModel: SearchListViewModel(shop: .mock)))
}
