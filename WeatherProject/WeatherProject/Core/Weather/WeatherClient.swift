//
//  WeatherClient.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

final class WeatherClient {
    static let shared = WeatherClient()
    
    let provider = NetworkProvider<WeatherEndPoint>()
    
    private init() {}
    
    func fetchWeather(_ model: WeatherRequest) async throws -> Weather {
        return try await provider.request(.fetchWeather(model))
    }
}
