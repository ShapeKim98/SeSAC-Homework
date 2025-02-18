//
//  SearchViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import Foundation

import Alamofire

@MainActor
protocol SearchViewModelDelegate: AnyObject {
    func pushShopList(query: String, shop: ShopResponse)
    func presentAlert(title: String?, message: String?)
}

@MainActor
final class SearchViewModel {
    enum Input {
        case searchBarSearchButtonClicked(_ text: String?)
    }
    
    enum Output {
        case isLoading(_ value: Bool)
    }
    
    struct Model {
        var isLoading: Bool = false {
            didSet {
                guard oldValue != isLoading else { return }
                continuation?.yield(.isLoading(isLoading))
            }
        }
        
        var continuation: AsyncStream<Output>.Continuation?
    }
    
    deinit { model.continuation?.finish() }
    
    private(set) var model = Model()
    
    weak var delegate: (any SearchViewModelDelegate)?
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    func input(_ action: Input) {
        switch action {
        case let .searchBarSearchButtonClicked(text):
            guard let text, text.filter(\.isLetter).count >= 2 else {
                delegate?.presentAlert(title: "두 글자 이상 입력해주세요.", message: nil)
                return
            }
            guard !text.filter(\.isLetter).isEmpty else {
                delegate?.presentAlert(title: "글자를 포함해주세요.", message: nil)
                return
            }
            Task { [weak self] in
                guard let self else { return }
                await fetchShop(query: text)
            }
            return
        }
    }
}

private extension SearchViewModel {
    func fetchShop(query: String) async {
        model.isLoading = true
        defer { model.isLoading = false }
        let request = ShopRequest(query: query)
        do {
            let shop = try await ShopClient.shared.fetchShop(request)
//            dump(shop)
            guard shop.total > 0 else {
                delegate?.presentAlert(title: "검색 결과가 없어요.", message: nil)
                return
            }
            delegate?.pushShopList(query: query, shop: shop)
        } catch {
            print((error as? AFError) ?? error)
        }
    }
}
