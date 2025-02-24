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
    
    static func make(_ id: Int?) -> Self {
        switch id {
        case 1: return .따끔따끔
        case 2: return .방실방실
        case 3: return .반짝반짝
        default: return .준비중
        }
    }
    
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
    
    var introduce: String {
        switch self {
        case .방실방실:
            return """
            저는 방실방실 다마고치입니당
            키는 100km 몸무게는 150톤이에용
            성격은 화끈하고 날라다닙니당~!
            열심히 잘 먹고 잘 클 자신은 있답니당 방실방실!
            """
        case .따끔따끔:
            return """
            저는 따끔따끔 다마고치입니당!
            키는 80km 몸무게는 130톤이에용
            성격은 찌릿찌릿, 톡톡 튀고 약간 쏘는 재치가 있답니당~!
            어디서든 살짝 살짝
            눈에 띄는 매력을 뽐내며 매일 신나게 활동한답니당 따끔따끔!
            """
        case .반짝반짝:
            return """
            저는 반짝반짝 다마고치입니당!
            키는 120km 몸무게는 200톤이라구요.
            성격은 빛나는 에너지와 따스한 반짝임으로 모두의 시선을 사로잡은답니당~!
            매 순간 반짝반짝 즐겁게 빛나며
            멋진 하루를 보내는 게 제 특기랍니다니당 반짝반짝!
            """
        case .준비중: return ""
        }
    }
}
