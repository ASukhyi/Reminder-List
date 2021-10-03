//
//  Reminder.swift
//  ToDoList
//
//  Created by Андрей on 25.09.2021.
//

import Foundation

struct Reminder {
    
    var id: String
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

