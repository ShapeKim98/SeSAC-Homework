//
//  WeatherEndPoint.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

import Alamofire

enum WeatherEndPoint: EndPoint {
    case fetchWeather(_ model: WeatherRequest)
    
    var path: String {
        switch self {
        case .fetchWeather: return "/data/2.5/weather"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchWeather: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchWeather(model):
            let mirror = Mirror(reflecting: model)
            var queryItems: Parameters = [:]
            for child in mirror.children {
                queryItems.updateValue(
                    child.value,
                    forKey: child.label ?? ""
                )
            }
            return queryItems
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
