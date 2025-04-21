//
//  FavoriteView.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/20/25.
//

import SwiftUI

import Dependencies

struct FavoriteView: View {
    @Dependency(CoinGeckoClient.self)
    private var client
    
    @State
    @Shared(.userDefaults(.favoriteIds))
    private var sharedFavoriteIds = [String]()
    @State
    private var path: [String] = []
    @State
    private var favoriteIds = [String]()
    @State
    private var favoriteCoins: [CoinDetail] = []
    @State
    private var timerTask: Task<Void, Never>?
    @State
    private var onDisappeared: Bool = false
    
    private let timer = Timer.publish(
        every: 10,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        NavigationStack(path: $path, root: root)
            .task(bodyTask)
            .onReceive(timer) { _ in
                timerOnReceive()
            }
            .onDisappear {
                onDisappeared = true
            }
    }
}

// MARK: - Configure View
private extension FavoriteView {
    func root() -> some View {
        VStack {
            ScrollView(.horizontal, content: content)
            
            Spacer()
        }
        .navigationTitle("Favorite")
        .navigationDestination(for: String.self) { id in
            CoinDetailView(id: id)
        }
    }
    
    func content() -> some View {
        LazyHStack {
            ForEach(favoriteCoins) { coin in
                NavigationLink(value: coin.id) {
                    FavoriteCell(coin: coin)
                }
                .buttonStyle(.plain)
            }
        }
        .fixedSize()
        .padding(16)
    }
    
    struct FavoriteCell: View {
        private let coin: CoinDetail
        
        init(coin: CoinDetail) {
            self.coin = coin
        }
        
        var body: some View {
            VStack(spacing: 40) {
                HStack(spacing: 4) {
                    thumbnail
                    
                    nameInfo
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                priceInfo
            }
            .frame(width: 140, alignment: .leading)
            .padding(12)
            .background(.background, in: RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            ))
            .shadow(color: .gray.opacity(0.2), radius: 4)
            .animation(.smooth, value: coin)
        }
        
        @ViewBuilder
        private var thumbnail: some View {
            AsyncImage(url: URL(string: coin.image)) { phase in
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
                Text(coin.name)
                    .font(.headline)
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        
        private var priceInfo: some View {
            VStack(alignment: .trailing, spacing: 4) {
                Text("₩" + Int(coin.currentPrice).formatted())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .contentTransition(.numericText())
                    .animation(.default, value: coin.currentPrice)
                
                let percentage = coin.priceChangePercentage24h ?? 0
                let color: Color = percentage > 0
                ? .red : percentage < 0
                ? .blue : .primary
                let format = percentage > 0 ? "+%.2f" : "%.2f"
                
                Text("\(String(format: format, percentage))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
                    .animation(.default, value: percentage)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(color.opacity(0.2), in: RoundedRectangle(
                        cornerRadius: 4,
                        style: .continuous
                    ))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Functions
private extension FavoriteView {
    @Sendable
    func bodyTask() async {
        onDisappeared = false
        favoriteIds = sharedFavoriteIds ?? []
        
        do {
            let request = CoinDetailRequest(ids: favoriteIds.joined(separator: ","))
            let response = try await client.fetchCoinDetail(request)
            favoriteCoins = response
        } catch {
            print(error)
        }
    }
    
    func timerOnReceive() {
        timerTask?.cancel()
        guard !onDisappeared else { return }
        
        timerTask = Task {
            do {
                let request = CoinDetailRequest(ids: favoriteIds.joined(separator: ","))
                let response = try await client.fetchCoinDetail(request)
                favoriteCoins = response
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    FavoriteView()
}
