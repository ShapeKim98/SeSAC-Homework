//
//  Shop.swift
//  DoBongShopping
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

struct Shop: Decodable, Sendable, Hashable {
    var total: Int
    let display: Int
    var items: [Item]
}

extension Shop {
    struct Item: Decodable, Sendable, Hashable {
        let productId: String
        let title: String
        let image: String
        let lprice: String
        let mallName: String
        let link: String
    }
}

extension Shop {
    static let mock = Shop(
        total: 6815460,
        display: 10,
        items: [
            Item(
                productId: "54166345466",
                title: "아이폰14프로블루 128GB 아이폰구입처 (특가폰 신청) KT직영대리점",
                image: "https://shopping-phinf.pstatic.net/main_5416634/54166345466.jpg",
                lprice: "1",
                mallName: "싼올레폰",
                link: "http://www.show010.co.kr/index.html?branduid=3247633&ref=naver_open"
            ),
            Item(
                productId: "52186859501",
                title: "Apple 아이폰15 128G 선보상 특가폰 공식KT샵",
                image: "https://shopping-phinf.pstatic.net/main_5218685/52186859501.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2782704&ref=naver_open"
            ),
            Item(
                productId: "46695654676",
                title: "아이폰15 디자인 128GB 강변휴대폰방문 (추천 특가폰) 온라인 KT샵",
                image: "https://shopping-phinf.pstatic.net/main_4669565/46695654676.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2778228&ref=naver_open"
            ),
            Item(
                productId: "46310847826",
                title: "아이폰13미니 가격 128GB 차세대스마트폰 (반값할인 특가폰) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4631084/46310847826.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2777555&ref=naver_open"
            ),
            Item(
                productId: "46425826301",
                title: "아이폰14 언팩 256GB 휴대폰 온라인결합 (전환지원금 반값할인) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4642582/46425826301.jpg",
                lprice: "1",
                mallName: "싼올레폰",
                link: "http://www.show010.co.kr/index.html?branduid=3253211&ref=naver_open"
            ),
            Item(
                productId: "46479056971",
                title: "아이폰14 아일랜드 128GB KT핸드폰대리점 (전환지원금 반값할인) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4647905/46479056971.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2777831&ref=naver_open"
            ),
            Item(
                productId: "46191727031",
                title: "아이폰14플러스 출시 256GB 초등학생추천폰 (특가폰 반값할인 ) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4619172/46191727031.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2777287&ref=naver_open"
            ),
            Item(
                productId: "45321889716",
                title: "아이폰14프로 딥퍼플 128GB 애플공식대리점 (추천 특가폰) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4532188/45321889716.jpg",
                lprice: "1",
                mallName: "싼올레폰",
                link: "http://www.show010.co.kr/index.html?branduid=3251594&ref=naver_open"
            ),
            Item(
                productId: "44924009986",
                title: "아이폰14플러스 128GB 매장 휴대폰홈쇼핑 (추천 특가폰) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4492400/44924009986.jpg",
                lprice: "1",
                mallName: "싼올레폰",
                link: "http://www.show010.co.kr/index.html?branduid=3250999&ref=naver_open"
            ),
            Item(
                productId: "44923221236",
                title: "아이폰13미니 128GB 기기변경이란 (추천 특가폰) KT 온라인샵",
                image: "https://shopping-phinf.pstatic.net/main_4492322/44923221236.jpg",
                lprice: "1",
                mallName: "KT가입센터",
                link: "http://www.ssaphone.co.kr/index.html?branduid=2774340&ref=naver_open"
            )
        ]
    )
}


