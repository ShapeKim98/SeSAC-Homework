//
//  SearchView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/16/25.
//

import SwiftUI

import SwiftUI

struct SearchView: View {
    @Environment(\.shopClient)
    private var shopClient
    @State
    private var path = [Shop.Item]()
    @State
    private var shop: Shop?
    @State
    private var query = ""
    @State
    private var queryOnChangeTask: Task<Void, Never>?
    @State
    private var isLoading = false
    @State
    private var favoriteItems = Set<Shop.Item>()
    @State
    private var page: Int = 1
    
    private var shopList: [Shop.Item] {
        return shop?.items ?? []
    }
    
    private let column = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]
    
    var body: some View {
        NavigationStack(path: $path, root: root)
            .preferredColorScheme(.dark)
    }
}

// MARK: - Configure Views
private extension SearchView {
    func root() -> some View {
        ScrollView(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .overlay {
                if isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
            .task(bodyTask)
            .searchable(text: $query, prompt: "검색")
            .onChange(of: query, queryOnChange)
            .animation(.easeInOut, value: shopList)
            .navigationTitle("쇼핑")
            .navigationDestination(for: Shop.Item.self) { item in
                ShopCell(
                    item: item,
                    favoriteItems: $favoriteItems
                )
            }
    }
    
    func content() -> some View {
        LazyVStack(spacing: 20) {
            LazyVGrid(columns: column, spacing: 12) {
                ForEach(shopList, id: \.productId) { item in
                    NavigationLink(value: item) {
                        ShopCell(
                            item: item,
                            favoriteItems: $favoriteItems
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .transition(.opacity)
            
            if let total = shop?.total,
               total > shopList.count {
                ProgressView()
                    .controlSize(.large)
                    .task(pageProgressViewTask)
            }
        }
    }
}

// MARK: - Functions
private extension SearchView {
    @Sendable
    func bodyTask() async {
        await fetchShopList()
    }
    
    @Sendable
    func fetchShopList() async {
        guard query.filter(\.isLetter).count >= 2 else { return }
        isLoading = true
        defer { isLoading = false }
        
        page = 1
        
        do {
            let request = ShopRequest(query: query)
            let response = try await shopClient.fetchShop(request)
            shop = response
        } catch {
            print(error)
        }
    }
    
    @Sendable
    func pageProgressViewTask() async {
        guard
            let shop = shop,
            query.filter(\.isLetter).count >= 2
        else { return }
        
        page += 1
        
        do {
            let request = ShopRequest(
                query: query,
                start: page,
                display: shop.display,
                sort: "sim"
            )
            let response = try await shopClient.fetchShop(request)
            self.shop?.total = response.total
            self.shop?.items.append(contentsOf: response.items)
        } catch {
            print(error)
        }
    }
    
    func queryOnChange(_ newValue: String, _ oldValue: String) {
        queryOnChangeTask?.cancel()
        
        queryOnChangeTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            
            await fetchShopList()
        }
    }
}

#Preview {
    SearchView()
}
