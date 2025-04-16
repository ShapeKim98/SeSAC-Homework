//
//  tsBackgroundModifier.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/14/25.
//

import SwiftUI

struct TSBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(.secondary.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .clipped()
    }
}

extension View {
    func tsBackground() -> some View {
        modifier(TSBackgroundModifier())
    }
}
