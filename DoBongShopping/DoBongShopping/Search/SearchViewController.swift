//
//  SearchViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit
import Alamofire
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SearchViewModel) {
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
}

//MARK: Configure View
private extension SearchViewController {
    func configureUI() {
        view.backgroundColor = .black
        view.gestureRecognizers = [
            UITapGestureRecognizer(
                target: self,
                action: #selector(tagGestureRecognizerAction)
            )
        ]
        
        configureNavigation()
        
        configureSearchBar()
        
        configureIndicatorView()
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        
        navigationController?
            .navigationBar
            .titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureSearchBar() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.barTintColor = .black
        searchBar.barStyle = .black
        searchBar.searchTextField.backgroundColor = .secondaryLabel
        searchBar.searchTextField.textColor = .white
        view.addSubview(searchBar)
    }
    
    func configureIndicatorView() {
        indicatorView.isHidden = true
        indicatorView.color = .white
        view.addSubview(indicatorView)
    }
}

// MARK: Data Bindings
private extension SearchViewController {
    typealias Action = SearchViewModel.Action
    
    func bindAction() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .map { Action.searchBarSearchButtonClicked($0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindIsLoading()
    }
    
    func bindIsLoading() {
        viewModel.observableState
            .map(\.isLoading)
            .distinctUntilChanged()
            .drive(with: self) { this, isLoading in
                this.indicatorView.isHidden = !isLoading
                
                if isLoading {
                    this.indicatorView.startAnimating()
                } else {
                    this.indicatorView.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Functions
private extension SearchViewController {
    @objc
    func tagGestureRecognizerAction() {
        view.endEditing(true)
    }
}

#Preview {
    UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel()))
}
