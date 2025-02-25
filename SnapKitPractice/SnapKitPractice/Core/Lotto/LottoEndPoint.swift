//
//  LottoEndPoint.swift
//  SnapKitPractice
//
//  Created by 김도형 on 2/24/25.
//

import Foundation

import Alamofire

enum LottoEndPoint: EndPoint, URLRequestConvertible {
    case fetchLotto(_ model: LottoRequest)
    
    var path: String {
        switch self {
        case .fetchLotto: return "/common.do"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchLotto: return .get
        }
    }
    
    var headers: HTTPHeaders {
        return []
    }
    
    var decoder: JSONDecoder { JSONDecoder() }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: "https://www.dhlottery.co.kr")?
            .asURL()
            .appendingPathComponent(path)
        guard let url else {
            throw AFError.invalidURL(url: "https://www.dhlottery.co.kr\(path)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.headers = headers
        switch self {
        case let .fetchLotto(model):
            request = try URLEncodedFormParameterEncoder().encode(
                model,
                into: request
            )
        }
        return request
    }
}
