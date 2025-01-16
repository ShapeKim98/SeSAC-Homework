//
//  ShopResponse.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct ShopResponse: Decodable, Sendable {
    public var total: Int
    public var start: Int
    public let display: Int
    public var items: [Item]
}

extension ShopResponse {
    public struct Item: Decodable, Sendable {
        public let title: String
        public let image: String
        public let lprice: String
        public let mallName: String
    }
}

public extension ShopResponse {
    static let mock = ShopResponse(
        total: 549489,
        start: 1,
        display: 10,
        items: [
            ShopResponse.Item(
                title: "쌍용 렉스턴 칸 스포츠 차박 캠핑카 [위드모빌] 위드칸 세미캠핑카 픽업트럭",
                image: "https://shopping-phinf.pstatic.net/main_8608144/86081448534.2.jpg",
                lprice: "25800000",
                mallName: "위드모빌"
            ),
            ShopResponse.Item(
                title: "오프로드 캠핑 트레일러 캠핑카 여행",
                image: "https://shopping-phinf.pstatic.net/main_5141760/51417600702.20241115215513.jpg",
                lprice: "8097190",
                mallName: "네이버"
            ),
            ShopResponse.Item(
                title: "스타렉스 침상 / DIY 캠핑카 차박 자작 5밴 3밴 수납 서랍 스타리아",
                image: "https://shopping-phinf.pstatic.net/main_8329466/83294662516.jpg",
                lprice: "1190000",
                mallName: "왕달구지"
            ),
            ShopResponse.Item(
                title: "이티밴 라이프 4인승 전기 캠핑카로 차박 가족여행 및 일상 패밀리 데일리카 전기 캠퍼밴 전국 보조금 문의하기",
                image: "https://shopping-phinf.pstatic.net/main_8873240/88732407327.jpg",
                lprice: "17390000",
                mallName: "제이스오토샵"
            ),
            ShopResponse.Item(
                title: "1톤캠핑카 트럭캠퍼 포터캠핑카 카라반 캠핑트레일러 어부바캠핑  1개",
                image: "https://shopping-phinf.pstatic.net/main_5144272/51442720435.jpg",
                lprice: "3500000",
                mallName: "쿠팡"
            ),
            ShopResponse.Item(
                title: "소형 카라반 트레일러 RV 미니 캠핑카 글램핑 감성",
                image: "https://shopping-phinf.pstatic.net/main_5187962/51879622007.jpg",
                lprice: "17564610",
                mallName: "11번가"
            ),
            ShopResponse.Item(
                title: "썬캠프 캠핑카 카라반 어닝텐트 어닝룸텐트 스위프트 디럭스 260",
                image: "https://shopping-phinf.pstatic.net/main_8230871/82308714745.2.jpg",
                lprice: "369000",
                mallName: "JUNIS Caravan"
            ),
            ShopResponse.Item(
                title: "[VBOF] 소형 캠핑카 [카라반 트레일러]",
                image: "https://shopping-phinf.pstatic.net/main_8767559/87675592295.1.jpg",
                lprice: "8000000",
                mallName: "V.BOF"
            ),
            ShopResponse.Item(
                title: "스타렉스캠핑카 개방감 넘치는 미니마스터 우드감성캠핑카",
                image: "https://shopping-phinf.pstatic.net/main_8368123/83681238566.jpg",
                lprice: "9750000",
                mallName: "JJRV캠핑카"
            ),
            ShopResponse.Item(
                title: "스타리아 스타렉스 캠핑카 개조 제작 4 5인승 차박 평탄화 키트 매트 180도 리클라이너 시트 당일 장착가능",
                image: "https://shopping-phinf.pstatic.net/main_8383586/83835864524.4.jpg",
                lprice: "3500000",
                mallName: "비캠프 대한캠핑카"
            )
        ]
    )
}


