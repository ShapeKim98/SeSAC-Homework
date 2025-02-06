//
//  ShopListViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/6/25.
//

import Foundation

import Alamofire

@MainActor
final class SearchListViewModel {
    enum Input {
        case collectionViewPrefetchItemsAt(query: String)
        case collectionViewCellForItemAt(query: String)
        case sortButtonTouchUpInside(query: String, sort: Sort)
    }
    
    enum Output {
        case shopItems(_ value: ShopResponse?)
        case selectedSort(_ value: Sort)
        case isLoading(_ value: Bool)
    }
    
    struct Model {
        var shop: ShopResponse {
            didSet {
                if oldValue.items != shop.items {
                    continuation?.yield(.shopItems(shop))
                }
            }
        }
        var selectedSort: Sort = .sim {
            didSet {
                guard oldValue != selectedSort else { return }
                continuation?.yield(.selectedSort(selectedSort))
            }
        }
        var isLoading: Bool = false {
            didSet {
                guard oldValue != isLoading else { return }
                continuation?.yield(.isLoading(isLoading))
            }
        }
        
        var continuation: AsyncStream<Output>.Continuation?
    }
    
    deinit { model.continuation?.finish() }
    
    private(set) var model: Model
    private var isPaging: Bool = false
    
    init(shop: ShopResponse) {
        self.model = Model(shop: shop)
    }
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    func input(_ action: Input) {
        switch action {
        case let .collectionViewPrefetchItemsAt(query):
            Task { await paginationShop(query) }
        case let .collectionViewCellForItemAt(query):
            Task { await paginationShop(query) }
        case let .sortButtonTouchUpInside(query, sort):
            model.selectedSort = sort
            Task { await fetchShop(query) }
        }
    }
}

private extension SearchListViewModel {
    func fetchShop(_ query: String) async {
        model.isLoading = true
        defer { model.isLoading = false }
        
        let request = ShopRequest(
            query: query,
            sort: model.selectedSort.rawValue
        )
        do {
            model.shop = try await ShopClient.shared.fetchShop(request)
        } catch {
            print((error as? AFError) ?? error)
        }
    }
    
    func paginationShop(_ query: String) async {
        guard
            !isPaging,
            model.shop.items.count < model.shop.total
        else { return }
        
        isPaging = true
        defer { isPaging = false }
        
        let request = ShopRequest(
            query: query,
            start: model.shop.items.count + 1,
            sort: model.selectedSort.rawValue
        )
        do {
            let shop = try await ShopClient.shared.fetchShop(request)
            model.shop.items += shop.items
            model.shop.total = shop.total
        } catch {
            print((error as? AFError) ?? error)
        }
    }
}
