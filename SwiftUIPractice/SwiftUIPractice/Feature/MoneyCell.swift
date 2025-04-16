//
//  MoneyCell.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//


import SwiftUI

struct MoneyCell: View {
    private let money: Money
    
    init(money: Money) {
        self.money = money
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(money.product)
                    .font(.headline)
                
                Text(money.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(money.amount.formatted() + "원")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        
    }
}