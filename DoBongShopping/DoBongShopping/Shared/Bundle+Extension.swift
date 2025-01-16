//
//  Bundle+Extension.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public extension Bundle {
    var naverClientId: String {
        return infoDictionary?["NAVER_CLIENT_ID"] as? String ?? ""
    }
    
    var naverClientSecret: String {
        return infoDictionary?["NAVER_CLIENT_SECRET"] as? String ?? ""
    }
}
