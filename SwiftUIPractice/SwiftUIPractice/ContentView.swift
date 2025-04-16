//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    @State
    private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            switch selectedTab {
            case .home:
                HomeView()
                    .toolbarBackground(.hidden, for: .tabBar)
            case .mission:
                MissionView()
                    .toolbarBackground(.hidden, for: .tabBar)
            case .randomImage:
                MyRandomImageView()
                    .toolbarBackground(.hidden, for: .tabBar)
            case .jackWallet:
                JackWalletView()
                    .toolbarBackground(.hidden, for: .tabBar)
            }
        }
        .overlay(alignment: .bottom) {
            tabBar
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
    
    enum Tab: CaseIterable {
        case home
        case mission
        case randomImage
        case jackWallet
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .mission: return "혜택"
            case .randomImage: return "랜덤 이미지"
            case .jackWallet: return "지갑"
            }
        }
        
        var image: String {
            switch self {
            case .home: return "house.fill"
            case .mission: return "diamond.fill"
            case .randomImage: return "photo.fill"
            case .jackWallet: return "wallet.pass.fill"
            }
        }
    }
}

private extension ContentView {
    @ViewBuilder
    func tabItem(_ tab: Tab) -> some View {
        let isSelected = selectedTab == tab
        
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                Image(systemName: tab.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? .white : .secondary)
                
                Text(tab.title)
                    .font(.subheadline)
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    var tabBar: some View {
        HStack {
            ForEach(Tab.allCases, id: \.hashValue) { tab in
                tabItem(tab)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 28)
        .padding(.horizontal, 16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .roundedCorner(20, corners: [.topLeft, .topRight])
    }
}

#Preview {
    ContentView()
}
