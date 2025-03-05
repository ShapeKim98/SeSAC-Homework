//
//  WishFolder.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

struct WishFolder: Hashable {
    let id: UUID
    let name: String
    var items: [Wish]
    let date: Date
}
