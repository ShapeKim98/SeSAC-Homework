//
//  RealmProvider.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/5/25.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

struct RealmProvider<T: Object> {
    private let realm = try! Realm()
    
    func write<O>(withoutNotifying tokens: [NotificationToken] = [], _ block: (() throws -> O)) throws -> O {
        try realm.write(withoutNotifying: tokens, block)
    }
    
    func create(_ object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func readAll() -> Results<T> {
        realm.objects(T.self)
    }
    
    func read<K>(_ forPrimaryKey: K) -> T? {
        realm.object(ofType: T.self, forPrimaryKey: forPrimaryKey)
    }
    
    func delete<K>(_ forPrimaryKey: K) throws {
        guard let object = read(forPrimaryKey) else { return }
        try realm.write {
            realm.delete(object)
        }
    }
    
    func update<K>(_ forPrimaryKey: K) throws {
        guard let object = read(forPrimaryKey) else { return }
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func observable() -> Observable<RealmCollectionChange<Results<T>>> {
        let realm = self.realm
        
        return BehaviorRelay<RealmCollectionChange<Results<T>>>.create { observer in
            let token = realm.objects(T.self)
                .observe { changes in
                    observer.onNext(changes)
                }
            
            return Disposables.create { token.invalidate() }
        }
    }
}
