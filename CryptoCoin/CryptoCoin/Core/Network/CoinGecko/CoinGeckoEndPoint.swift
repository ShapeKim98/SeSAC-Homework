//
//  CoinGeckoEndPoint.swift
//  CoinCo
//
//  Created by 김도형 on 3/9/25.
//

import Foundation

import Alamofire

enum CoinGeckoEndPoint: EndPoint {
    case trending
    case search(_ model: SearchRequest)
    case markets(_ model: CoinDetailRequest)
    
    var baseURL: URL? { URL(string: Bundle.main.coingeckoURL) }
    
    var path: String {
        switch self {
        case .trending: return "/search/trending"
        case .search: return "/search"
        case .markets: return "/coins/markets"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .trending,
             .search,
             .markets:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        ["x-cg-demo-api-key": Bundle.main.coingeckoAPIKey]
    }
    
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    var encoder: ParameterEncoder? {
        switch self {
        case .trending: return nil
        case .search: return .urlEncodedForm
        case .markets:
            let encoder = URLEncodedFormEncoder(boolEncoding: .literal)
            return URLEncodedFormParameterEncoder(encoder: encoder)
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .trending: return nil
        case let .search(model):
            return model
        case let .markets(model):
            return model
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> Error {
        switch statusCode {
        case 400, 404: return CoinGeckoError(error: "잘못된 요청이에요.")
        case 401: return CoinGeckoError(error: "인증이 필요해요.")
        case 403, 1020: return CoinGeckoError(error: "접근이 제한되었어요.")
        case 429: return CoinGeckoError(error: "요청이 너무 많아요.")
        case 500: return CoinGeckoError(error: "서버가 불안정해요.")
        case 503: return CoinGeckoError(error: "서버 이용이 불가해요.")
        default:
            do {
                let baseError = try JSONDecoder().decode(CoinGeckoError.self, from: data)
                return baseError
            } catch { return error }
        }
    }
}
