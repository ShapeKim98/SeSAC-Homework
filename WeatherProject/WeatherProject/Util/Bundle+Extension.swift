//
//  Bundle+Extension.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        return infoDictionary?["API_KEY"] as? String ?? ""
    }
}
