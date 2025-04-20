//
//  TrendingView.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/20/25.
//

import SwiftUI

import Dependencies

struct TrendingView: View {
    @Dependency(CoinGeckoClient.self)
    private var client
    
    @State
    private var coins: [Trending.TrendingCoinItem]?
    @State
    private var nfts: [Trending.TrendingNFTItem]?
    @State
    private var favoriteIds: [String] = ["bitCoin"]
    
    @State
    private var path: [String] = []
    
    private let trendingListRows = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(content: content)
                .navigationTitle("Cryto Coin")
                .task(bodyTask)
        }
    }
}

// MARK: - Configure Views
private extension TrendingView {
    func content() -> some View {
        VStack(spacing: 40) {
            if !favoriteIds.isEmpty {
                favoriteSection
            }
            
            let coins = coins ?? Trending.mock.coins
            trendingSection(
                title: "Top 15 Coin",
                items: coins
            ) { coin in
                let index = coins.firstIndex(of: coin)
                
                return NavigationLink(value: coin.id) {
                    TrendingCell(
                        rank: (index ?? 0) + 1,
                        image: coin.item.small,
                        title: coin.item.name,
                        symbol: coin.item.symbol,
                        price: String(format: "$%.4f", coin.item.data.price),
                        percentage: coin.item.data.priceChangePercentage24h.usd
                    )
                    .animation(.smooth, value: self.coins)
                    .redacted(reason: self.coins == nil ? [.placeholder] : [])
                }
                .buttonStyle(.plain)
            }
            
            let nfts = nfts ?? Trending.mock.nfts
            
            trendingSection(
                title: "Top 7 NFT",
                items: nfts
            ) { nft in
                let index = nfts.firstIndex(of: nft)
                
                return TrendingCell(
                    rank: (index ?? 0) + 1,
                    image: nft.thumb,
                    title: nft.name,
                    symbol: nft.symbol,
                    price: nft.data.floorPrice,
                    percentage: nft.floorPrice24hPercentageChange
                )
                .animation(.smooth, value: self.nfts)
                .redacted(reason: self.nfts == nil ? [.placeholder] : [])
            }
        }
        .padding(.top, 20)
    }
    
    func trendingSection<T: Identifiable>(
        title: String,
        items: [T],
        content: @escaping (T) -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 32) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                trendingList(items: items, content: content)
                    .padding(.horizontal, 16)
            }
        }
    }
    
    func trendingList<T: Identifiable>(
        items: [T],
        content: @escaping (T) -> some View
    ) -> some View {
        LazyHGrid(rows: trendingListRows, spacing: 16) {
            ForEach(items, content: content)
        }
    }
    
    var favoriteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Favorite")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(favoriteIds, id: \.hashValue) { id in
                        FavoriteCell(id: id)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    struct TrendingCell: View {
        private let rank: Int
        private let image: String
        private let title: String
        private let symbol: String
        private let price: String
        private let percentage: Double
        
        init(
            rank: Int,
            image: String,
            title: String,
            symbol: String,
            price: String,
            percentage: Double
        ) {
            self.rank = rank
            self.image = image
            self.title = title
            self.symbol = symbol
            self.price = price
            self.percentage = percentage
        }
        
        var body: some View {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Text("\(rank)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    thumbnail
                    
                    nameInfo
                    
                    Spacer()
                    
                    priceInfo
                }
                .padding(.horizontal, 8)
                
                Divider()
                    .opacity(rank % 3 != 0 ? 1 : 0)
            }
            .frame(width: 320)
        }
        
        private var thumbnail: some View {
            AsyncImage(url: URL(string: image)) { phase in
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
                Text(title)
                    .font(.headline)
                
                Text(symbol)
                    .font(.caption)
            }
        }
        
        private var priceInfo: some View {
            VStack(alignment: .trailing, spacing: 4) {
                Text(price)
                    .font(.subheadline)
                
                let color: Color = percentage > 0
                ? .red : percentage < 0
                ? .blue : .primary
                let format = percentage > 0 ? "+%.2f" : "%.2f"
                Text("\(String(format: format, percentage))%")
                    .font(.caption)
                    .foregroundStyle(color)
            }
        }
    }
    
    struct FavoriteCell: View {
        @Dependency(CoinGeckoClient.self)
        var client
        
        private let id: String
        
        @State
        private var coin: CoinDetail?
        
        init(id: String) {
            self.id = id
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 40) {
                HStack(spacing: 4) {
                    thumbnail
                    
                    nameInfo
                }
                
                priceInfo
            }
            .frame(width: 160, alignment: .leading)
            .padding(16)
            .background(.quaternary, in: RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            ))
            .redacted(reason: coin == nil ? [.placeholder] : [])
            .animation(.smooth, value: coin)
            .task(bodyTask)
        }
        
        @ViewBuilder
        private var thumbnail: some View {
            if let image = coin?.image {
                AsyncImage(url: URL(string: image)) { phase in
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
        }
        
        private var nameInfo: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(coin?.name ?? CoinDetail.mock.name)
                    .font(.headline)
                
                let symbol = coin?.symbol ?? CoinDetail.mock.symbol
                Text(symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        
        private var priceInfo: some View {
            VStack(alignment: .leading, spacing: 4) {
                let price = coin?.currentPrice ?? CoinDetail.mock.currentPrice
                Text("₩" + Int(price).formatted())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                let percentage = coin?.priceChangePercentage24h ?? 0
                let color: Color = percentage > 0
                ? .red : percentage < 0
                ? .blue : .primary
                let format = percentage > 0 ? "+%.2f" : "%.2f"
                Text("\(String(format: format, percentage))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
            }
        }
        
        @Sendable
        private func bodyTask() async {
            do {
                /// 임시
                try? await Task.sleep(for: .seconds(1))
                
                let request = CoinDetailRequest(ids: id)
                let response = try await client.fetchCoinDetail(request).first
                guard let response else { return }
                coin = response
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Functions
private extension TrendingView {
    @Sendable
    func bodyTask() async {
        do {
            /// 임시
            try? await Task.sleep(for: .seconds(1))
            
            let response = try await client.fetchTrending()
            coins = response.coins
            nfts = response.nfts
        } catch {
            print(error)
        }
    }
}

#Preview {
    TrendingView()
}
