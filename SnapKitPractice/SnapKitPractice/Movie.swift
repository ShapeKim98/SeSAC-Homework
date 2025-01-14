//
//  Movie.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/13/25.
//

import Foundation

public struct Movie {
    public let number: Int
    public let title: String
    public let date: String
}

public extension Movie {
    static let mock = [
        Movie(number: 1, title: "엽문4: 더 파이널", date: "2020-04-01"),
        Movie(number: 2, title: "주디", date: "2020-03-25"),
        Movie(number: 3, title: "1917", date: "2020-02-19"),
        Movie(number: 4, title: "인비저블", date: "2020-02-26"),
        Movie(number: 5, title: "n번째 이별 중", date: "2020-04-01"),
        Movie(number: 6, title: "스케어리 스토리: 어둠속의 속삭임", date: "2020-03-25"),
        Movie(number: 7, title: "날씨의 아이", date: "2019-10-30"),
        Movie(number: 8, title: "라라랜드", date: "2016-12-07"),
        Movie(number: 9, title: "너의 이름은.", date: "2017-01-04"),
        Movie(number: 10, title: "다크 워터스", date: "2020-03-11"),
    ]
}
