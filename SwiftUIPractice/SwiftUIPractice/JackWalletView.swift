//
//  JackWalletView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//

import SwiftUI

struct JackWalletView: View {
    @State
    private var path: [Money] = []
    @State
    private var moneyList = dummy
    
    var body: some View {
        NavigationStack(path: $path, root: root)
            
    }
}

private extension JackWalletView {
    func root() -> some View {
        ScrollView(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Jack Wallet")
            .navigationDestination(for: Money.self) { money in
                MoneyDetailView(money: money)
            }
    }
    
    func content() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(moneyList) { money in
                Button {
                    path.append(money)
                } label: {
                    MoneyCell(money: money)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    JackWalletView()
}
