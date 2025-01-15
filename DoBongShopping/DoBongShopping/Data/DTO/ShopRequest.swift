//
//  ShopRequest.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct ShopRequest {
    public let query: String
    public let start: Int
    public let display: Int
    public let sort: Sort
}

extension ShopRequest {
    public enum Sort: String {
        case sim = "sim"
        case date = "date"
        case asc = "asc"
        case dsc = "dsc"
    }
}
