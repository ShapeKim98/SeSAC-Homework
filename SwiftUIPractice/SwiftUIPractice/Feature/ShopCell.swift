//
//  ShopCell.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/16/25.
//


import SwiftUI
import SwiftUI

struct ShopCell: View {
    @Binding
    private var favoriteItems: Set<Shop.Item>
    
    private let item: Shop.Item
    
    init(
        item: Shop.Item,
        favoriteItems: Binding<Set<Shop.Item>>
    ) {
        self.item = item
        self._favoriteItems = favoriteItems
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: item.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Color.secondary
                @unknown default:
                    Color.secondary
                }
            }
            .clipShape(RoundedRectangle(
                cornerRadius: 12,
                style: .continuous)
            )
            .clipped()
            .overlay(alignment: .topLeading) {
                favoriteButton
                    .padding(8)
            }
            
            Text(item.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            price
        }
        .tsBackground()
    }
    
    private var price: some View {
        HStack {
            Text(Int(item.lprice)?.formatted() ?? "")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text(item.mallName)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    private var favoriteButton: some View {
        let isFavorite = favoriteItems.contains(item)
        
        Button {
            if favoriteItems.remove(item) == nil {
                favoriteItems.insert(item)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.pink)
                .animation(.easeInOut, value: isFavorite)
        }
    }
}
