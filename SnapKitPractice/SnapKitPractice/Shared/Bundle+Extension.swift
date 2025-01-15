//
//  Bundle+Extension.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public extension Bundle {
    var kobisApiKey: String {
        return infoDictionary?["KOBIS_API_KEY"] as? String ?? ""
    }
}
