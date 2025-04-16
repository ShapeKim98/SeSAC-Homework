//
//  MyRandomImageView.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/15/25.
//

import SwiftUI

struct MyRandomImageView: View {
    var body: some View {
        NavigationStack {
            ScrollView(content: content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("My Random Image")
        }
    }
}

private extension MyRandomImageView {
    func content() -> some View {
        VStack(spacing: 20) {
            section(title: "첫번째 섹션")
            
            section(title: "두번째 섹션")
            
            section(title: "세번째 섹션")
            
            section(title: "네번째 섹션")
            
            section(title: "다섯번째 섹션")
        }
        .padding(.vertical, 20)
    }
    
    func section(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<20) { _ in
                        imageCell
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    var imageCell: some View {
        let url = URL(string: "https://picsum.photos/id/\(Int.random(in: 1...200))/200/300")
        
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure:
                Color.secondary
            @unknown default:
                Color.secondary
            }
        }
        .frame(width: 100, height: 150)
        .clipShape(RoundedRectangle(
            cornerRadius: 20,
            style: .continuous
        ))
        .clipped()
    }
}

#Preview {
    MyRandomImageView()
}
