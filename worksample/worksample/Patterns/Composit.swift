//
//  Composit.swift
//  worksample
//
//  Created by Григорий Мартюшин on 26.03.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

protocol Task {
    var name: String { get set }
    var count: Int { get set }
    var subTask: [Task] { get }
    
    func add (task: Task) -> Void
}

class ConcreteTask: Task {
    var name: String
    var count: Int = 0
    var subTask: [Task] = []

    func add (task: Task) {
        
    }
    
    init (name: String) {
        self.name = name
    }
}

class CompositeTask: Task {
    var count: Int
    
    var name: String
    var subTask = [Task]()
    
    init (name: String, tasks: [Task]) {
        self.name = name
        self.subTask = tasks
        self.count = tasks.count
    }
    
    func add (task: Task) {
        subTask.append(task)
        count += 1
    }
}
