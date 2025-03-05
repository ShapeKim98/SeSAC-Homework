//
//  WebViewModel.swift
//  DoBongShopping
//
//  Created by 김도형 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

@MainActor
final class WebViewModel: Composable {
    enum Action {
        case favoriteButtonTapped
    }
    
    struct State {
        @RealmTable
        var shopItemTable: Results<ShopItemTable>
        let item: ShopResponse.Item
        var isFavorite: Bool {
            $shopItemTable.findObject(item.productId) != nil
        }
        @PresentState
        var toastMessage: String?
    }
    
    @ComposableState var state: State
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    init(item: ShopResponse.Item) {
        state = State(item: item)
        
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .favoriteButtonTapped:
            let productId = state.item.productId
            let item = state.$shopItemTable.findObject(productId)
            
            do {
                if let item {
                    try state.$shopItemTable.delete(item)
                    state.toastMessage = "\(state.item.title.removeHTMLTags()) 좋아요 취소"
                } else {
                    try state.$shopItemTable.create(state.item.toObject())
                    state.toastMessage = "\(state.item.title.removeHTMLTags()) 좋아요 추가"
                }
            } catch {
                
            }
            return .none
        }
    }
}
