//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class TaskItem {
    var id: UUID
    var name: String
    var descr: String
    var dueTime: Date
    var completed: Bool
    var dateCompletedAt: Date? = nil
    var pet: MyPet
    
    var hasPassedDue: Bool {
        return Date() > dueTime
    }
    
    var deco: (taskImage: String, taskBgColor: Color, taskImageColor: Color) {
        if completed {
            return (taskImage: "checkmark.circle.fill",
                    taskBgColor: Color.white,
                    taskImageColor: Color.accentColor)
        }
        
        return (taskImage: "circle",
                taskBgColor: Color.white,
                taskImageColor: Color.black)
    }
    
    init (
        id: UUID = UUID(),
        name: String,
        descr: String,
        dueTime: Date,
        completed: Bool,
        dateCompletedAt: Date? = nil,
        pet: MyPet
    ) {
        self.id = id
        self.name = name
        self.descr = descr
        self.dueTime = dueTime
        self.completed = completed
        self.dateCompletedAt = dateCompletedAt
        self.pet = pet
    }
}
