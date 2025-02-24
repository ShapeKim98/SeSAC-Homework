//
//  BoxOfficeDTO.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/15/25.
//

import Foundation

public struct BoxOfficeDTO: Decodable {
    public let boxOfficeResult: BoxOfficeResult
}

extension BoxOfficeDTO {
    public struct BoxOfficeResult: Decodable {
        public let dailyBoxOfficeList: [DailyBoxOffice]
    }
}

extension BoxOfficeDTO.BoxOfficeResult {
    public struct DailyBoxOffice: Decodable {
        public let rank: String
        public let movieNm: String
        public let openDt: String
    }
}

public extension BoxOfficeDTO {
    static let mock = BoxOfficeDTO(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [
        .init(rank: "1", movieNm: "엽문4: 더 파이널", openDt: "2020-04-01"),
        .init(rank: "2", movieNm: "주디", openDt: "2020-03-25"),
        .init(rank: "3", movieNm: "1917", openDt: "2020-02-19"),
        .init(rank: "4", movieNm: "인비저블", openDt: "2020-02-26"),
        .init(rank: "5", movieNm: "n번째 이별 중", openDt: "2020-04-01"),
        .init(rank: "6", movieNm: "스케어리 스토리: 어둠속의 속삭임", openDt: "2020-03-25"),
        .init(rank: "7", movieNm: "날씨의 아이", openDt: "2019-10-30"),
        .init(rank: "8", movieNm: "라라랜드", openDt: "2016-12-07"),
        .init(rank: "9", movieNm: "너의 이름은.", openDt: "2017-01-04"),
        .init(rank: "10", movieNm: "다크 워터스", openDt: "2020-03-11"),
    ]))
}
