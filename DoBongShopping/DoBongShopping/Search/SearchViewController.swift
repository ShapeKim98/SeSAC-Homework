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
    let searchBar = UISearchBar()
    
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
        
        configureNavigtion()
        
        configureSearchBar()
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureNavigtion() {
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
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
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        guard query.count >= 2 else {
            presentAlert(
                title: "검색어 오류",
                message: "두 글자 이상 입력해주세요."
            )
            return
        }
        
        Task { [weak self] in
            guard let `self` else { return }
            let request = ShopRequest(query: query)
            do {
                let shop = try await ShopClient.shared.fetchShop(request).toEntity()
                self.navigationController?.pushViewController(
                    ShopListViewController(query: query, shop: shop),
                    animated: true
                )
            } catch {
                print(error as? AFError)
            }
        }
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
