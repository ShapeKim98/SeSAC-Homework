//
//  ShopRequest.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct ShopRequest: Sendable {
    public let query: String
    public let start: Int
    public let display: Int
    public let sort: String
    
    public init(
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
