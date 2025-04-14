//
//  WishListViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class WishListViewModel: Composable {
    enum Action {
        case searchButtonClicked(String)
        case collectionViewItemSelected(Int)
        case viewDidLoad
        case bindCollection(CollectionChange<[Wish]>)
    }
    
    struct State {
        var folder: WishFolder
    }
    
    @ComposableState var state: State
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    private let useCase = WishListUseCase(
        wishRepository: WishRepository(),
        wishFolderRepository: WishFolderRepository()
    )
    
    init(wishFolder: WishFolder) {
        self.state = State(folder: wishFolder)
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return .run(useCase.observable().map { Action.bindCollection($0) })
        case let .searchButtonClicked(text):
            let with = Wish(id: UUID(), name: text, date: .now)
            do {
                try useCase.create(with, from: state.folder)
            } catch { print(error) }
            return .none
        case .bindCollection:
            guard let items = useCase.readFolder(state.folder.id)?.items else {
                return .none
            }
            state.folder.items = items
            return .none
        case let .collectionViewItemSelected(index):
            do {
                try useCase.delete(state.folder.items[index])
            } catch { print(error) }
            return .none
        }
    }
}
