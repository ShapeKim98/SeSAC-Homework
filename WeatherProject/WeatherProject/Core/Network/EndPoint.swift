//
//  EndPoint.swift
//  WeatherProject
//
//  Created by 김도형 on 2/3/25.
//

import Foundation

import Alamofire

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}
