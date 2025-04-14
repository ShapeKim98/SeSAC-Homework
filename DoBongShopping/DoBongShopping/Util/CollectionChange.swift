//
//  CollectionChange.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

enum CollectionChange<T> {
    case initial(T)
    case update(T, deletions: [Int], insertions: [Int], modifications: [Int])
    case error(Error)
}
