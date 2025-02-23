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
        case viewDidLoad
        case bindSharedCaptain
    }
    
    struct State {
        var settingItems: [SettingItem] = []
    }
    
    private let state = BehaviorRelay(value: State())
    var observableState: Driver<State> { state.asDriver() }
    let send = PublishRelay<Action>()
    private let disposeBag = DisposeBag()
    
    @Shared(.userDefaults(.captain))
    var captain: String?
    @Shared(.userDefaults(.rice))
    var rice: Int?
    @Shared(.userDefaults(.waterDrop))
    var waterDrop: Int?
    @Shared(.userDefaults(.level))
    var level: Int?
    @Shared(.userDefaults(.tamagotchiId))
    var tamagotchiId: Int?
    
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
        case .alertConfirmButtonTapped:
            captain = nil
            rice = nil
            waterDrop = nil
            level = nil
            
            tamagotchiId = nil
            return .none
        case .viewDidLoad:
            @Shared(.userDefaults(.captain))
            var captain: String?
            
            state.settingItems = SettingType.allCases.map { type in
                SettingItem(
                    type: type,
                    name: type == .nameEdit ? captain : nil
                )
            }
            return .run(
                $captain.map { _ in Action.bindSharedCaptain },
                disposeBag: disposeBag
            )
        case .bindSharedCaptain:
            state.settingItems.removeFirst()
            let type = SettingType.nameEdit
            state.settingItems.insert(
                SettingItem(
                    type: type,
                    name: captain
                ),
                at: 0
            )
            return .none
        }
    }
}

extension SettingViewModel {
    enum SettingType: CaseIterable {
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
            case .reset: return "arrow.clockwise"
            }
        }
    }
    
    struct SettingItem: Equatable {
        let type: SettingType
        var title: String { type.title }
        var imageName: String { type.imageName }
        var name: String?
    }
}
