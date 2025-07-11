//
//  SearchView.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/20/25.
//

import SwiftUI

import Dependencies

struct SearchView: View {
    @Dependency(CoinGeckoClient.self)
    private var client
    
    @State
    private var path: [String] = []
    @State
    private var searchItems: [Search.SearchItem] = []
    @State
    private var query: String = ""
    @State
    private var searchOnSubmitTask: Task<Void, Never>?
    @State
    private var isLoading = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(content: content)
                .navigationTitle("Search")
                .navigationDestination(for: String.self) { id in
                    CoinDetailView(id: id)
                }
                .searchable(
                    text: $query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("검색어를 입력해주세요.")
                )
                .onSubmit(of: .search, searchOnSubmit)
        }
    }
}

// MARK: - Configure Views
private extension SearchView {
    func content() -> some View {
        LazyVStack(spacing: 20) {
            let items = isLoading ? Search.mock.coins : searchItems
            ForEach(items) { item in
                NavigationLink(value: item.id) {
                    SearchCell(item: item)
                }
                .buttonStyle(.plain)
            }
        }
        .redacted(reason: isLoading ? [.placeholder] : [])
        .padding(.horizontal, 16)
        .padding(.top, 28)
    }
    
    struct SearchCell: View {
        @State
        @Shared(.userDefaults(.favoriteIds))
        private var sharedFavoriteIds = [String]()
        @State
        private var isFavorite = false
        
        private let item: Search.SearchItem
        
        init(item: Search.SearchItem) {
            self.item = item
        }
        
        var body: some View {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    thumbnail
                    
                    nameInfo
                    
                    Spacer()
                    
                    favoriteButton
                }
            }
            .onAppear(perform: bodyOnAppear)
        }
        
        private var thumbnail: some View {
            AsyncImage(url: URL(string: item.thumb)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.secondary
                @unknown default:
                    Color.secondary
                }
            }
            .frame(width: 32, height: 32)
            .clipped()
        }
        
        private var nameInfo: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(item.symbol)
                    .font(.caption)
            }
        }
        
        private var favoriteButton: some View {
            Button(action: favoriteButtonAction) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.purple)
                    .animation(.smooth, value: isFavorite)
            }
        }
        
        private func favoriteButtonAction() {
            if isFavorite {
                sharedFavoriteIds?.removeAll(where: { $0 == item.id })
            } else {
                sharedFavoriteIds?.insert(item.id, at: 0)
            }
            guard let sharedFavoriteIds else { return }
            isFavorite = sharedFavoriteIds.contains(item.id)
        }
        
        private func bodyOnAppear() {
            guard let sharedFavoriteIds else { return }
            isFavorite = sharedFavoriteIds.contains(item.id)
        }
    }
}

// MARK: - Functions
private extension SearchView {
    func searchOnSubmit() {
        guard !query.filter(\.isLetter).isEmpty else {
            return
        }
        
        searchOnSubmitTask?.cancel()
        
        searchOnSubmitTask = Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let request = SearchRequest(query: query)
                let response = try await client.fetchSearch(request)
                searchItems = response.coins
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SearchView()
}
