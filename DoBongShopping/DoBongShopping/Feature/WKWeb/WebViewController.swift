//
//  WebViewController.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import UIKit
import WebKit

import SnapKit
import RxSwift
import RxCocoa

class WebViewController: UIViewController {
    private lazy var webView = { configureWKWebView() }()
    private let favoriteButton = UIBarButtonItem()
    
    private let viewModel: WebViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        configureNavigation()
        
        bindState()
        
        bindAction()
    }
    
    private func configureWKWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        view.addSubview(webView)
        return webView
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = favoriteButton
        favoriteButton.tintColor = .systemBlue
    }
}

// MARK: Bindings
private extension WebViewController {
    typealias Action = WebViewModel.Action
    
    func bindAction() {
        favoriteButton.rx.tap
            .map { Action.favoriteButtonTapped }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        viewModel.$state.driver
            .compactMap { URL(string: $0.item.link) }
            .drive(with: self) { this, url in
                this.webView.load(URLRequest(url: url))
            }
            .disposed(by: disposeBag)
        
        viewModel.$state.driver
            .map { $0.isFavorite ? "heart.fill" : "heart" }
            .map { UIImage(systemName: $0) }
            .drive(favoriteButton.rx.image)
            .disposed(by: disposeBag)
    }
}

