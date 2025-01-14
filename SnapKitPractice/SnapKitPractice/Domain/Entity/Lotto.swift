//
//  Lotto.swift
//  SnapKitPractice
//
//  Created by 김도형 on 1/14/25.
//

import Foundation

public struct Lotto: Decodable {
    public let drwNoDate: String
    public let drwNo: Int
    public let drwtNo1: Int
    public let drwtNo2: Int
    public let drwtNo3: Int
    public let drwtNo4: Int
    public let drwtNo5: Int
    public let drwtNo6: Int
    public let bnusNo: Int
}

public extension Lotto {
    static let mock = Lotto(
        drwNoDate: "2020-05-30",
        drwNo: 913,
        drwtNo1: 6,
        drwtNo2: 14,
        drwtNo3: 16,
        drwtNo4: 21,
        drwtNo5: 27,
        drwtNo6: 37,
        bnusNo: 40
    )
}
