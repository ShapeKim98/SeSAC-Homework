//
//  LottoClient.swift
//  SnapKitPractice
//
//  Created by 김도형 on 2/24/25.
//

import Foundation

import RxSwift

final class LottoClient {
    static let shared = LottoClient()
    
    private let provider = NetworkProvider<LottoEndPoint>()
    
    private init() {}
    
    func fetchLottoObservable(_ model: LottoRequest) -> Observable<Lotto> {
        let provider = self.provider
        return .create { observer in
            Task {
                do {
                    let response: Lotto = try await provider.request(.fetchLotto(model))
                    observer.onNext(response)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchLottoSingle(_ model: LottoRequest) -> Single<Lotto> {
        let provider = self.provider
        return .create { observer in
            Task {
                do {
                    let response: Lotto = try await provider.request(.fetchLotto(model))
                    observer(.success(response))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
