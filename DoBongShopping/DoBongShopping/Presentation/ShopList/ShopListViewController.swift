//
//  ShopListViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit
import Alamofire
import RxSwift
import RxCocoa

final class ShopListViewController: UIViewController {
    private let totalLabel = UILabel()
    private let sortButtonHStack = UIStackView()
    private var sortButtons = [SortButton]()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private let collectionViewController: ShopCollectionViewController
    
    private let viewModel: ShopListViewModel
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: ShopListViewModel) {
        self.viewModel = viewModel
        self.collectionViewController = ShopCollectionViewController(
            viewModel: viewModel.shopCollectionViewModel
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureCollectionViewController()
        
        configureLayout()
        
        bindState()
        
        bindAction()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        collectionViewController.willMove(toParent: nil)
        collectionViewController.view.removeFromSuperview()
        collectionViewController.removeFromParent()
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
        
        collectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(sortButtonHStack.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(collectionViewController.view)
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
    }
    
    func bindState() {
        bindShop()
        
        bindSelectedSort()
        
        bindIsLoading()
        
        bindQuery()
    }
    
    func bindShop() {
        viewModel.$state.driver
            .map(\.shop.total)
            .distinctUntilChanged()
            .map { "\($0.formatted())개의 검색 결과" }
            .drive(totalLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindSelectedSort() {
        viewModel.$state.driver
            .map(\.selectedSort)
            .distinctUntilChanged()
            .drive(with: self) { this, selectedSort in
                this.collectionViewController.scrollToTop()
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
        viewModel.$state.driver
            .map(\.isLoading)
            .distinctUntilChanged()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func bindQuery() {
        viewModel.$state.driver
            .map(\.query)
            .distinctUntilChanged()
            .drive(navigationItem.rx.title)
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
        
        viewModel.$state.driver
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
    UINavigationController(
        rootViewController: ShopListViewController(
            viewModel: ShopListViewModel(query: "캠핑카", shop: .mock)
        )
    )
}
