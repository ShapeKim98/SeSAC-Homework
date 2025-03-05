//
//  ShopEndPoint.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/16/25.
//

import Foundation

import Alamofire

enum ShopEndPoint: EndPoint, Sendable {
    case fetchShop(_ model: ShopRequest)
    
    var path: String {
        switch self {
        case .fetchShop: return "/v1/search/shop.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchShop: return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case let .fetchShop(model):
            return [
                URLQueryItem(name: "query", value: model.query),
                URLQueryItem(name: "display", value: "\(model.display)"),
                URLQueryItem(name: "start", value: "\(model.start)"),
                URLQueryItem(name: "sort", value: "\(model.sort)")
            ]
        }
    }
}
