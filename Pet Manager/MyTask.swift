//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [MyTask] = [
        MyTask(
            name: "Feed Jupiter",
            description: "Only half a can per serving!",
            pet: "Jupiter",
            dueTime: Date().addingTimeInterval(60*60)
        ),
        MyTask(
            name: "Lock Cat Door",
            description: "Or in only mode if Jupiter can't be found...",
            pet: "Jupiter",
            dueTime: Date().addingTimeInterval(-60*30)
        ),
        MyTask(
            name: "Feed Fishy",
            description: "Use the pellets on the counter",
            pet: "Fishy",
            dueTime: Date().addingTimeInterval(60*10)
        )
    ]
    
    @Published var completedTasks = 0
    @Published var selectedTask: MyTask? = nil
    @Published var showConfirmation: Bool = false
}

struct MyTask: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var pet: String
    var dueTime: Date
    var completed: Bool = false
    
    var dueDescription: String {
        let now = Date()
        let formatter = RelativeDateTimeFormatter()
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
                    taskBgColor:  Color(red: 0.8, green: 1, blue: 0.8),
                    taskImageColor: Color.green)
        }
        else if hasPassedDue {
            return (taskImage: "exclamationmark.circle.fill",
                    taskBgColor: Color(red: 1, green: 0.8, blue: 0.8),
                    taskImageColor: Color.red)
        }
        
        return (taskImage: "pawprint.circle.fill",
                taskBgColor: Color.white,
                taskImageColor: Color.gray)
    }
}
