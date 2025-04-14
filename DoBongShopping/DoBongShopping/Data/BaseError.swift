//
//  BaseError.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/25/25.
//

import Foundation

struct BaseError: Decodable, Sendable, Error {
    let errorMessage: String
    let errorCode: String
}
