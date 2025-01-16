//
//  EndPoint.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/16/25.
//

import Foundation

import Alamofire

protocol EndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
}
