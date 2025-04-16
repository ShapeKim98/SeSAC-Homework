//
//  MoneyDetailView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//

import SwiftUI

struct MoneyDetailView: View {
    private let money: Money
    
    init(money: Money) {
        self.money = money
    }
    
    var body: some View {
        VStack {
            MoneyCell(money: money)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MoneyDetailView(money: dummy.first!)
}
