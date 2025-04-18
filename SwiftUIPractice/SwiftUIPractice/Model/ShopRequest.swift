//
//  ShopRequest.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

struct ShopRequest: Encodable {
    let query: String
    let start: Int
    let display: Int
    let sort: String
    
    init(
        query: String,
        start: Int = 1,
        display: Int = 30,
        sort: String = "sim"
    ) {
        self.query = query
        self.start = start
        self.display = display
        self.sort = sort
    }
}
