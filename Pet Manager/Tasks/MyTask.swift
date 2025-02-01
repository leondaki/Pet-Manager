//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI

class MyTask: Identifiable, ObservableObject, Equatable {
    static func == (lhs:MyTask, rhs:MyTask) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    
    @Published var name: String
    @Published var description: String
    @Published var pet: Pet
    @Published var dueTime: Date
    @Published var completed: Bool
    @Published var dateCompletedAt: Date? = nil
    
    init(name: String, description: String, pet: Pet, completed: Bool, dueTime: Date) {
        self.name = name
        self.description = description
        self.pet = pet
        self.completed = completed
        self.dueTime = dueTime
    }
    
    var dueDescription: String {
        //let now = Date()
        //let formatter = RelativeDateTimeFormatter()
        //formatter.unitsStyle = .full // Options: .full, .short, .abbreviated

        // return "Due \(formatter.localizedString(for: dueTime, relativeTo: now))"
        return "\(dueTime)"
    }
    
    var hasPassedDue:Bool {
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
}
