//
//  LottoViewModel.swift
//  SnapKitPractice
//
//  Created by 김도형 on 2/24/25.
//

import Foundation

import RxSwift
import RxCocoa

final class LottoViewModel: Composable {
    enum Action {
        case viewDidLoad
        case bindLotto(Lotto)
        case drwNoPickImteSelected(Int)
    }
    
    struct State {
        var lotto: Lotto?
        var drwNos: [String] = []
        var lotteryDay: Int?
        var lotteryRange = [String]()
        var selectedDate: String?
    }
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    private let lottoClient = LottoClient.shared
    
    init() {
        send
            .observe(on: MainScheduler.asyncInstance)
            .debug("\(Self.self): Received Action")
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state.value
                this.reducer(&state, action)
                    .compactMap(\.action)
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            let firstLottery = "2002-12-07"
            guard
                let date = firstLottery.date(format: .yyyy_MM_dd)
            else { return .none }
            let count = Calendar.current
                .dateComponents(
                    [.weekdayOrdinal],
                    from: date,
                    to: .now
                )
                .weekdayOrdinal ?? 0
            state.lotteryDay = count + 1
            guard let lotteryDay = state.lotteryDay else {
                return .none
            }
            
            state.lotteryRange = Array(1...lotteryDay)
                .reversed()
                .map { String($0) }
            let request = LottoRequest(drwNo: "\(lotteryDay)")
            let fetchLottoSingle = lottoClient.fetchLottoSingle(request)
            return .run(fetchLottoSingle.asObservable().map { .bindLotto($0) }) { error in
                return .none
            }
        case let .bindLotto(lotto):
            state.lotto = lotto
            state.selectedDate = lotto.drwNoDate
            state.drwNos = [
                "\(lotto.drwtNo1)",
                "\(lotto.drwtNo2)",
                "\(lotto.drwtNo3)",
                "\(lotto.drwtNo4)",
                "\(lotto.drwtNo5)",
                "\(lotto.drwtNo6 )",
                "+",
                "\(lotto.bnusNo)"
            ]
            return .none
        case let .drwNoPickImteSelected(row):
            state.selectedDate = state.lotteryRange[row]
            return .none
        }
    }
}
