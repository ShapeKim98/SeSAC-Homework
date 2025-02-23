//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import Foundation

enum Tamagotchi: String, CaseIterable {
    case 따끔따끔
    case 방실방실
    case 반짝반짝
    case 준비중
    
    var name: String? {
        guard self != .준비중 else { return nil }
        return rawValue + " 다마고치"
    }
    var id: Int? {
        switch self {
        case .따끔따끔: return 1
        case .방실방실: return 2
        case .반짝반짝: return 3
        default: return nil
        }
    }
}
