//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI

class MyTask: Identifiable, ObservableObject, Equatable {
    static func == (lhs: MyTask, rhs: MyTask) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    
    var name: String
    var description: String
    var pet: String
    var dueTime: Date
    var dateCompletedAt: Date? = nil
    
    init(name: String, description: String, pet: String, dueTime: Date) {
        self.name = name
        self.description = description
        self.pet = pet
        self.dueTime = dueTime
    }
    
    @Published var completed: Bool = false
    
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
    
    var colors: (taskImage: String, taskBgColor: Color, taskImageColor: Color) {
        if completed {
            return (taskImage: "checkmark.circle.fill",
                    taskBgColor: Color.white,
                    taskImageColor: Color.green)
        }
        else if hasPassedDue {
            return (taskImage: "exclamationmark.circle.fill",
                    taskBgColor: Color(red: 1, green: 0.8, blue: 0.8),
                    taskImageColor: Color.red)
        }
        
        return (taskImage: "pawprint.circle.fill",
                taskBgColor: Color.white,
                taskImageColor: Color.black)
    }
}
