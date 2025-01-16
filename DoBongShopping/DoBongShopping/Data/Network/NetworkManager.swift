//
//  NetworkManager.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/16/25.
//

import Foundation

import Alamofire

struct NetworkManager<E: EndPoint>: Sendable {
    func request<T: Decodable & Sendable>(_ endPoint: E) async throws -> T {
        var urlComponent = URLComponents(string: "https://openapi.naver.com")
        urlComponent?.path = endPoint.path
        urlComponent?.queryItems = endPoint.parameters
        
        let url = urlComponent?.url?.absoluteString
        guard let url else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        let header = HTTPHeaders([
            "X-Naver-Client-Id": Bundle.main.naverClientId,
            "X-Naver-Client-Secret": Bundle.main.naverClientSecret
        ])
        
        return try await withCheckedThrowingContinuation { continuation in
            AF
                .request(url, method: .get, headers: header)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
//                        dump(data)
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}