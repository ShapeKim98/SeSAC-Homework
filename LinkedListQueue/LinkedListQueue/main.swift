//
//  main.swift
//  LinkedListQueue
//
//  Created by 김도형 on 4/7/25.
//

import Foundation

var queue = Queue<String>()
queue.push(with: "Hue")
queue.push(with: "Jack")
queue.push(with: "Bran")
queue.push(with: "Den")

print(queue)
queue.pop()
print(queue)
