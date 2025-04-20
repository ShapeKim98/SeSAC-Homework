//
//  Mission.swift
//  SwiftUIPractice
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

struct Mission: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let isNew: Bool
    let image: String
    
    init(
        title: String,
        subtitle: String,
        isNew: Bool = false,
        image: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isNew = isNew
        self.image = image
    }
}

extension [Mission] {
    static let sample: [Mission] = [
        Mission(title: "오늘의 행운복권", subtitle: "포인트 받기", image: "leaf.fill"),
        Mission(title: "라이브 쇼핑", subtitle: "포인트 받기", image: "tv.fill"),
        Mission(title: "행운퀴즈", subtitle: "추가 혜택 보기", image: "q.square.fill"),
        Mission(title: "이번 주 미션", subtitle: "얼마 받을지 보기", image: "figure.archery"),
        Mission(title: "두근두근 1등 찍기", subtitle: "포인트 받기", isNew: true, image: "checkmark.circle.fill"),
        Mission(title: "일주일 방문 미션", subtitle: "포인트 받기", image: "calendar"),
        Mission(title: "머니 알림", subtitle: "포인트 받기", image: "bell.fill"),
        Mission(title: "등록한 현금영수증 도착", subtitle: "10원 받기", image: "printer.filled.and.paper.inverse"),
        Mission(title: "진행중인 이벤트", subtitle: "모아보기", image: "gift.fill")
    ]
}
