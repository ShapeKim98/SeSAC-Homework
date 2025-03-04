//
//  RealmState.swift
//  DoBongShopping
//
//  Created by 김도형 on 3/4/25.
//

import Foundation

import RealmSwift

@propertyWrapper
struct RealmTable<T: Object> {
    private let realm = try! Realm()
    
    init() {
        print(realm.configuration.fileURL)
    }
    
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
        print(object)
        return object
    }
    
    func observe(block: @escaping NotificationBlock) -> NotificationToken {
        realm.observe(block)
    }
}
