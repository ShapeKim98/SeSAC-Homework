//
//  Movie.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import Foundation

public struct BoxOffice {
    public let rank: String
    public let movieNm: String
    public let openDt: String
}

extension BoxOfficeDTO.BoxOfficeResult.DailyBoxOffice {
    func toEntity() -> BoxOffice {
        return BoxOffice(
            rank: self.rank,
            movieNm: self.movieNm,
            openDt: self.openDt
        )
    }
}

extension BoxOfficeDTO.BoxOfficeResult {
    func toEntity() -> [BoxOffice] {
        return self.dailyBoxOfficeList.map { $0.toEntity() }
    }
}

extension BoxOfficeDTO {
    func toEntity() -> [BoxOffice] {
        return self.boxOfficeResult.toEntity()
    }
}
