//
//  Weather.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

struct Weather: Decodable {
    let main: Main
    let wind: Wind
    let dt: TimeInterval
}

extension Weather {
    struct Main: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double
    }
}
