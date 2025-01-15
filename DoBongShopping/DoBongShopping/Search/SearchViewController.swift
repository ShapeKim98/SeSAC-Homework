//
//  SearchViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import UIKit

import SnapKit

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
        
    }
}

#Preview {
    UINavigationController(rootViewController: SearchViewController())
}
