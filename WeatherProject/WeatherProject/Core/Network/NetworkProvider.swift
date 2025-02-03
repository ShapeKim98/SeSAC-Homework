//
//  NetworkProvider.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

import Alamofire

struct NetworkProvider<E: EndPoint>: Sendable {
    func request<T: Decodable & Sendable>(_ endPoint: E) async throws -> T {
        let url = try ("https://api.openweathermap.org" + endPoint.path).asURL()
        
        let response = await AF.request(
            url,
            method: endPoint.method,
            parameters: endPoint.parameters,
            encoding: URLEncoding.queryString,
            headers: endPoint.headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(T.self)
        .response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
