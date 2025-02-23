//
//  InGameViewModel.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/20/25.
//

import Foundation

import RxSwift
import RxCocoa

final class InGameViewModel: Composable {
    enum Action {
        case riceButtonTapped(String)
        case waterDropButtonTapped(String)
        case viewDidAppear
        case alertConfirmButtonTapped
        case bindSharedCaptain
        case viewDidLoad
        case bindSharedTamagotchiId
    }
    
    struct State {
        @Shared(.userDefaults(.captain))
        var captain: String?
        @Shared(.userDefaults(.waterDrop))
        var waterDrop: Int?
        @Shared(.userDefaults(.rice))
        var rice: Int?
        @Shared(.userDefaults(.level))
        var level: Int?
        @Shared(.userDefaults(.tamagotchiId))
        var tamagotchiId: Int?
        var tamagotchiName: String? {
            Tamagotchi.make(tamagotchiId).name
        }
        var alertMessage: String?
        var message = Message.random()
    }
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> {
        state.asDriver()
    }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    init() {
        send
            .observe(on: MainScheduler.asyncInstance)
            .debug("\(Self.self): Received Action")
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state.value
                this.reducer(&state, action)?
                    .compactMap(\.action)
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>>? {
        switch action {
        case let .riceButtonTapped(text):
            guard !text.isEmpty else {
                state.rice += 1
                updateLevel(&state)
                return .none
            }
            guard let riceInt = Int(text) else {
                state.alertMessage = "숫자만 입력해주세요"
                return .none
            }
            guard riceInt < 100 else {
                state.alertMessage = "한 번에 최대 99개까지 먹을 수 있어요"
                return .none
            }
            state.rice += riceInt
            updateLevel(&state)
            return .none
        case let .waterDropButtonTapped(text):
            guard !text.isEmpty else {
                state.waterDrop += 1
                updateLevel(&state)
                return .none
            }
            guard let waterDropInt = Int(text) else {
                state.alertMessage = "숫자만 입력해주세요"
                return .none
            }
            guard waterDropInt < 50 else {
                state.alertMessage = "한 번에 최대 49개까지 먹을 수 있어요"
                return .none
            }
            state.waterDrop += waterDropInt
            updateLevel(&state)
            return .none
        case .viewDidAppear:
            state.message = Message.random()
            return .none
        case .alertConfirmButtonTapped:
            state.alertMessage = nil
            return .none
        case .bindSharedCaptain:
            return .none
        case .bindSharedTamagotchiId:
            return .none
        case .viewDidLoad:
            return .merge(
                state.$captain.map { _ in Action.bindSharedCaptain },
                state.$tamagotchiId.map { _ in Action.bindSharedTamagotchiId },
                disposeBag: disposeBag
            )
        }
    }
}

private extension InGameViewModel {
    func updateLevel(_ state: inout State) {
        guard
            let rice = state.rice,
            let waterDrop = state.waterDrop
        else { return }
        
        let score = (Double(rice) / 5) + (Double(waterDrop) / 2)
        let oldLevel = state.level ?? 1
        switch score {
        case ..<20: state.level = 1
        case 20..<30 where oldLevel < 2: state.level = 2
        case 30..<40 where oldLevel < 3: state.level = 3
        case 40..<50 where oldLevel < 4: state.level = 4
        case 50..<60 where oldLevel < 5: state.level = 5
        case 60..<70 where oldLevel < 6: state.level = 6
        case 70..<80 where oldLevel < 7: state.level = 7
        case 80..<90 where oldLevel < 8: state.level = 8
        case 90..<100 where oldLevel < 9: state.level = 9
        case 100... where oldLevel < 10: state.level = 10
        default: break
        }
        if state.level ?? 1 > oldLevel {
            state.message = Message.밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님
        }
    }
}

extension InGameViewModel {
    enum Message: CaseIterable {
        case 복습_아직_안하셨다구요_지금_잠이_오세여_대장님
        case 대장님_오늘_깃허브_푸시_하셨어영
        case 대장님_밥주세여
        case 밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님
        
        func text(_ captain: String) -> String {
            switch self {
            case .복습_아직_안하셨다구요_지금_잠이_오세여_대장님:
                return "복습 아직 안하셨다구요? 지금 잠이 오세여? \(captain)님?"
            case .대장님_오늘_깃허브_푸시_하셨어영:
                return "\(captain)님 오늘 깃허브 푸시 하셨어영?"
            case .대장님_밥주세여:
                return "\(captain)님, 밥주세여"
            case .밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님:
                return "밥과 물을 잘먹었더니 레벨업 했어여 고마워요 \(captain)님"
            }
        }
        
        static func random() -> Message {
            allCases.filter { message in
                message != .밥과_물을_잘먹었더니_레벨업_했어여_고마워요_대장님
            }.randomElement() ?? .대장님_밥주세여
        }
    }
}
