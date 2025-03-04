//
//  RealmState.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

@propertyWrapper
struct RealmTable<T: Object> {
    private let realm = try! Realm()
    
    var wrappedValue: Results<T> {
        get { realm.objects(T.self) }
    }
    
    var projectedValue: RealmTable<T> { self }
    
    func create(_ object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func update(_ object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete(_ object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    func findObject<K>(_ forPrimaryKey: K) -> T? {
        let object = realm.object(ofType: T.self, forPrimaryKey: forPrimaryKey)
        return object
    }
    
    func observe(block: @escaping NotificationBlock) -> NotificationToken {
        realm.observe(block)
    }
    
    var observable: Observable<Realm> {
        return BehaviorRelay<Realm>.create { observer in
            let token = realm.observe { notification, realm in
                switch notification {
                case .didChange:
                    observer.onNext(realm)
                case .refreshRequired: break
                }
            }
            return Disposables.create { token.invalidate() }
        }
        .debug()
    }
}
