//
//  ShopListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit
import Alamofire

class ShopListViewController: UIViewController {
    private let totalLabel = UILabel()
    private let sortButtonHStack = UIStackView()
    private var sortButtons = [SortButton]()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private lazy var collectionView: UICollectionView = {
        configureCollectionView()
    }()
    
    private let query: String
    private var shop: ShopResponse? {
        didSet { didSetShop() }
    }
    private var selectedSort: Sort = .sim {
        didSet { didSetSelectedSort() }
    }
    private var isPaging: Bool = false
    
    init(
        query: String,
        shop: ShopResponse = .mock
    ) {
        self.query = query
        self.shop = shop
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
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
        totalLabel.text = "\(shop?.total.formatted() ?? "")개의 검색 결과"
        totalLabel.textColor = .systemGreen
        totalLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(totalLabel)
    }
    
    func configureSortButtonHStack() {
        sortButtonHStack.axis = .horizontal
        sortButtonHStack.distribution = .fill
        sortButtonHStack.spacing = 8
        sortButtonHStack.alignment = .leading
        view.addSubview(sortButtonHStack)
    }
    
    func configureSortButtons() {
        for sort in Sort.allCases {
            let button = SortButton(title: sort.title)
            button.isSelected(sort == selectedSort)
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
        let spacing: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (view.frame.width - (3 * spacing)) / 2
        layout.itemSize = CGSize(width: width, height: 300)
        layout.sectionInset = UIEdgeInsets(
            top: 8,
            left: 12,
            bottom: 12,
            right: 12
        )
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = spacing
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: .shopCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        
        return collectionView
    }
    
    func configureIndicatorView() {
        indicatorView.isHidden = true
        indicatorView.color = .white
        view.addSubview(indicatorView)
    }
}

// MARK: Data Bindings
private extension ShopListViewController {
    func didSetSelectedSort() {
        UIView.animate(.easeInOut) {
            for (index, sort) in Sort.allCases.enumerated() {
                sortButtons[index].isSelected(sort == selectedSort)
            }
        }
    }
    
    func didSetShop() {
        guard shop != nil else {
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            return
        }
        collectionView.reloadData()
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
    }
}

// MARK: Functions
private extension ShopListViewController {
    func sortButtonTouchUpInside(sort: Sort) {
        selectedSort = sort
        
        fetchShop()
    }
    
    func fetchShop() {
        Task { [weak self] in
            guard let `self` else { return }
            self.shop = nil
            let request = ShopRequest(
                query: self.query,
                display: 30,
                sort: self.selectedSort.rawValue
            )
            do {
                self.shop = try await ShopClient.shared.fetchShop(request)
                self.collectionView.scrollToItem(
                    at: IndexPath(item: 0, section: 0),
                    at: .top,
                    animated: true
                )
            } catch {
                print((error as? AFError) ?? error)
            }
        }
    }
    
    func paginationShop(call: Any) {
        guard
            !isPaging,
            let shop,
            shop.items.count < shop.total
        else { return }
        print(call)
        
        Task { [weak self] in
            guard let `self` else { return }
            isPaging = true
            defer { isPaging = false }
            
            let request = ShopRequest(
                query: self.query,
                start: shop.items.count,
                display: 30,
                sort: self.selectedSort.rawValue
            )
            do {
                let shop = try await ShopClient.shared.fetchShop(request)
                self.shop?.items += shop.items
                self.shop?.start = shop.start
                self.shop?.total = shop.total
            } catch {
                print((error as? AFError) ?? error)
            }
        }
    }
}

extension ShopListViewController: UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .shopCollectionCell,
            for: indexPath
        ) as? ShopCollectionViewCell
        guard
            let cell,
            let shop = self.shop
        else { return UICollectionViewCell() }
        
        cell.cellForItemAt(shop.items[indexPath.item])
        if indexPath.item + 1 == shop.items.count {
            paginationShop(call: #function)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let shopList = shop?.items else { return }
        for indexPath in indexPaths {
            guard
                indexPath.item + 2 == shopList.count
            else { continue }
            paginationShop(call: #function)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let shopCell = cell as? ShopCollectionViewCell
        shopCell?.cancelImageDownload()
    }
}

extension ShopListViewController {
    class SortButton: UIButton {
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

extension ShopListViewController {
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
}

//#Preview {
//    UINavigationController(rootViewController: ShopListViewController(query: "캠핑카"))
//}
