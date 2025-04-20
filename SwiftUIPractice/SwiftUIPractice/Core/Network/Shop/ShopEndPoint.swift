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
    
    
    var headers: HTTPHeaders {
        [
            "X-Naver-Client-Id": Bundle.main.naverClientId,
            "X-Naver-Client-Secret": Bundle.main.naverClientSecret
        ]
    }
    
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    var encoder: (any ParameterEncoder)? {
        switch self {
        case .fetchShop: return .urlEncodedForm
        }
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case let .fetchShop(model): return model
        }
    }
}
