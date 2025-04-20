//
//  HomeView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//

import SwiftUI

struct HomeView: View {
    private let marketPrices: [MarketPrice] = .sample
    
    var body: some View {
        ScrollView(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .preferredColorScheme(.dark)
            .ignoresSafeArea()
    }
}

private extension HomeView {
    func content() -> some View {
        VStack(spacing: 16) {
            stockMarketSection
            
            eventSection
            
            menuSection
        }
    }
    
    var stockMarketSection: some View {
        VStack(alignment: .leading, spacing: 32) {
            marketSection
            
            marketPriceSection
        }
        .padding(.top, 72)
        .background(.secondary.opacity(0.15))
    }
    
    var marketSection: some View {
        HStack(spacing: 8) {
            ForEach(MarketItem.allCases, id: \.rawValue) { type in
                MarketCell(type: type)
            }
        }
        .padding(.horizontal, 20)
    }
    
    var marketPriceSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(marketPrices) { market in
                    MarketPriceCell(market: market)
                }
            }
            .padding([.horizontal, .bottom], 20)
        }
    }
    
    var eventSection: some View {
        HStack(spacing: 16) {
            eventCell(title: "숨은 환급액\n찾기")
            
            eventCell(title: "혜택 받는\n신용카드")
        }
    }
    
    var menuSection: some View {
        VStack(spacing: 32) {
            ForEach(MenuItem.allCases, id: \.hashValue) { item in
                MenuCell(item: item)
            }
        }
        .tsBackground()
    }
    
    func eventCell(title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .tsBackground()
    }
}

private struct MarketCell: View {
    let type: HomeView.MarketItem
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "creditcard.fill")
            
            Text(type.rawValue)
                .font(.caption)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .tsBackground()
    }
}

private struct MarketPriceCell: View {
    private let market: MarketPrice
    
    init(market: MarketPrice) {
        self.market = market
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(market.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                price
            }
            
            Divider()
                .padding(.horizontal, 16)
        }
    }
    
    private var price: some View {
        HStack(spacing: 2) {
            Text(String(format: "%.2f", market.price))
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            let isPositive = market.fluctuation >= 0
            
            Text(String(
                format: isPositive ? "+%.1f" : "%.1f",
                market.fluctuation
            ) + "%")
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundStyle(
                isPositive ? .red : .blue
            )
        }
    }
}

private struct MenuCell: View {
    private let item: HomeView.MenuItem
    
    init(item: HomeView.MenuItem) {
        self.item = item
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            Text(item.rawValue)
                .font(.subheadline)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(.secondary)
        }
    }
}

private extension HomeView {
    enum MarketItem: String, CaseIterable {
        case 국내주식 = "국내주식"
        case 해외주식 = "해외주식"
        case 채권 = "채권"
        case eft = "ETF"
    }
    
    enum MenuItem: String, CaseIterable {
        case 내_현금영수증 = "내 현금영수증"
        case 내_보험료_점검하기 = "내 보험료 점검하기"
        case 더_낸_연말정산_돌려받기 = "더 낸 연말정산 돌려받기"
        
        var image: String {
            switch self {
            case .내_현금영수증:
                return "newspaper.fill"
            case .내_보험료_점검하기:
                return "headphones"
            case .더_낸_연말정산_돌려받기:
                return "desktopcomputer"
            }
        }
    }
}

#Preview {
    HomeView()
}
