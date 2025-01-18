//
//  SearchViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit
import Alamofire

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    private var isLoading = false {
        didSet { didSetIsLoading() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
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
        searchBar.delegate = self
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
    func didSetIsLoading() {
        indicatorView.isHidden = !isLoading
        
        if isLoading {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }
}

// MARK: Functions
private extension SearchViewController {
    @objc
    func tagGestureRecognizerAction() {
        view.endEditing(true)
    }
    
    func fetchShop(query: String) {
        Task { [weak self] in
            guard let `self` else { return }
            self.view.endEditing(true)
            self.isLoading = true
            defer { self.isLoading = false }
            let request = ShopRequest(query: query)
            do {
                let shop = try await ShopClient.shared.fetchShop(request)
                dump(shop)
                guard shop.total > 0 else {
                    presentAlert(title: "검색 결과가 없어요.")
                    return
                }
                self.navigationController?.pushViewController(
                    ShopListViewController(query: query, shop: shop),
                    animated: true
                )
            } catch {
                print((error as? AFError) ?? error)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        guard query.filter(\.isLetter).count >= 2 else {
            presentAlert(title: "두 글자 이상 입력해주세요.")
            return
        }
        guard !query.filter(\.isLetter).isEmpty else {
            presentAlert(title: "글자를 포함해주세요.")
            return
        }
        
        fetchShop(query: query)
    }
    
    func presentAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: SearchViewController())
}
