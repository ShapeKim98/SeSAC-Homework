//
//  UserViewModel.swift
//  MVVMProject
//
//  Created by 김도형 on 2/5/25.
//

import Foundation

class UserViewModel {
    enum Input {
        case resetButtonTapped
        case loadButtonTapped
        case addButtonTapped
    }
    
    enum Output {
        case people(_ oldValue: [Person], _ newValue: [Person])
    }
    
    struct Model {
        var people: [Person] = [] {
            didSet {
                continuation?.yield(.people(oldValue, people))
            }
        }
        
        var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model = Model()
    
    var output: AsyncStream<Output> {
        return AsyncStream<Output> { continuation in
            model.continuation = continuation
        }
    }
    
    deinit {
        model.continuation?.finish()
    }
    
    func input(_ action: Input) {
        switch action {
        case .resetButtonTapped:
            model.people.removeAll()
            return
        case .loadButtonTapped:
            model.people = [
                Person(name: "James", age: Int.random(in: 20...70)),
                Person(name: "Mary", age: Int.random(in: 20...70)),
                Person(name: "John", age: Int.random(in: 20...70)),
                Person(name: "Patricia", age: Int.random(in: 20...70)),
                Person(name: "Robert", age: Int.random(in: 20...70))
            ]
            return
        case .addButtonTapped:
            let names = ["James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda", "William", "Elizabeth", "David", "Barbara", "Richard", "Susan", "Joseph", "Jessica", "Thomas", "Sarah", "Charles", "Karen"]
            let user = Person(name: names.randomElement()!, age: Int.random(in: 20...70))
            model.people.append(user)
            return
        }
    }
}
