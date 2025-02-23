//
//  SettingViewModel.swift
//  Tamagotchi
//
//  Created by 김도형 on 2/23/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SettingViewModel: Composable {
    enum Action {
        case alertConfirmButtonTapped
    }
    
    struct State {
        @Shared(.userDefaults(.captain))
        var captain: String?
        var settingItems = SettingItem.allCases
    }
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    init() {
        send
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .compactMap { this, action in
                var state = this.state.value
                this.reducer(&state, action)?
                    .compactMap(\.action)
                    .debug("Received Action")
                    .bind(to: this.send)
                    .disposed(by: this.disposeBag)
                return state
            }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
    
    private func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>>? {
        switch action {
        case .alertConfirmButtonTapped:
            @Shared(.userDefaults(.rice))
            var rice: Int?
            @Shared(.userDefaults(.waterDrop))
            var waterDrop: Int?
            @Shared(.userDefaults(.level))
            var level: Int?
            @Shared(.userDefaults(.tamagotchiId))
            var tamagotchiId: Int?
            
            state.captain = nil
            rice = nil
            waterDrop = nil
            level = nil
            
            tamagotchiId = nil
            return .none
        }
    }
}

extension SettingViewModel {
    enum SettingItem: CaseIterable {
        case nameEdit
        case tamagotchiEdit
        case reset
        
        var title: String {
            switch self {
            case .nameEdit: return "내 이름 설정하기"
            case .tamagotchiEdit: return "다마고치 설정하기"
            case .reset: return "데이터 초기화"
            }
        }
        
        var imageName: String {
            switch self {
            case .nameEdit: return "pencil"
            case .tamagotchiEdit: return "leaf.fill"
            case .reset: return "arrow.trianglehead.clockwise"
            }
        }
    }
}
