//
//  ShopClient.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

import Alamofire

public class ShopClient {
    public static let shared = ShopClient()
    
    public func fetchShop(_ model: ShopRequest) async throws -> ShopResponse {
        var urlComponent = URLComponents(string: "https://openapi.naver.com/v1/search/shop.json")
        urlComponent?.queryItems = [
            URLQueryItem(name: "query", value: model.query),
            URLQueryItem(name: "display", value: "\(model.display)"),
            URLQueryItem(name: "start", value: "\(model.start)"),
            URLQueryItem(name: "sort", value: "\(model.sort)")
        ]
        let url = urlComponent?.url?.absoluteString
        guard let url else { throw AFError.parameterEncodingFailed(reason: .missingURL) }
        
        let header = HTTPHeaders([
            "X-Naver-Client-Id": Bundle.main.naverClientId,
            "X-Naver-Client-Secret": Bundle.main.naverClientSecret
        ])
        
        return try await withCheckedThrowingContinuation { continuation in
            AF
                .request(url, method: .get, headers: header)
                .responseDecodable(of: ShopResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        dump(data)
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
