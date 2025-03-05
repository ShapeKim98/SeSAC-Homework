//
//  WishListFolderViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class WishListFolderViewModel: Composable {
    enum Action {
        case searchButtonClicked(String)
        case collectionViewItemSelected(Int)
        case viewDidLoad
        case bindCollectionChange(CollectionChange<[WishFolder]>)
    }
    
    struct State {
        var wishList: [WishFolder] = []
        @PresentState
        var selectedFolder: WishFolder?
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init() { bindSend() }
    
    let useCase = WishListFolderUseCase(wishFolderRepository: WishFolderRepository())
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return .run(useCase.observable().map { Action.bindCollectionChange($0) })
        case let .searchButtonClicked(text):
            let with = WishFolder(
                id: UUID(),
                name: text,
                items: [],
                date: .now
            )
            do {
                try useCase.create(with)
            } catch { print(error) }
            return .none
        case let .collectionViewItemSelected(index):
            state.selectedFolder = state.wishList[index]
            return .none
        case .bindCollectionChange:
            state.wishList = useCase.readAll()
            return .none
        }
    }
}
