//
//  Wish.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

struct Wish: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let date: Date = .now
}
