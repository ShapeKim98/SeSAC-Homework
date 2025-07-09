//
//  ContentView.swift
//  CryptoCoin
//
//  Created by 김도형 on 4/20/25.
//

import SwiftUI

struct ContentView: View {
    @State
    private var selectedTab: TabItem = .trending
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                TrendingView()
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.trending)
                
                SearchView()
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.search)
                
                FavoriteView()
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.favorite)
                
                Color.white
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(TabItem.myPage)
            }
            
            tabBar
        }
    }
}

// MARK: - Configure Views
private extension ContentView {
    enum TabItem: CaseIterable {
        case trending
        case search
        case favorite
        case myPage
        
        var image: String {
            switch self {
            case .trending: return "chart.xyaxis.line"
            case .search: return "magnifyingglass"
            case .favorite: return "wallet.pass"
            case .myPage: return "person"
            }
        }
    }

    
    @ViewBuilder
    func tabItem(_ tab: TabItem) -> some View {
        let isSelected = selectedTab == tab
        let color: Color = isSelected ? .purple : .secondary
        
        Button {
            UISelectionFeedbackGenerator().selectionChanged()
            withAnimation(.spring(bounce: 0.3)) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: tab.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(color)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
        }
    }
    
    var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.hashValue) { tab in
                tabItem(tab)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(.background)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

#Preview {
    ContentView()
}
