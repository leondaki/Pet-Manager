//
//  TaskManager.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [MyTask] = [
        MyTask(
            name: "Feed Jupiter",
            description: "Only half a can per serving!",
            pet: "Mittens",
            dueTime: Date().addingTimeInterval(60*60)
        ),
        MyTask(
            name: "Lock  Buddy's Door",
            description: "Or in only mode if he can't be found...",
            pet: "Buddy",
            dueTime: Date().addingTimeInterval(-60*30)
        ),
        MyTask(
            name: "Feed Fishy",
            description: "Use the pellets on the counter",
            pet: "Charlie",
            dueTime: Date().addingTimeInterval(60*10)
        )
    ]
    
    @Published var numTasksDone = 0
    @Published var selectedTask: MyTask? = MyTask(
        name: "Feed Jupiter",
        description: "Only half a can per serving!",
        pet: "Mittens",
        dueTime: Date().addingTimeInterval(60*60)
    )
    @Published var showConfirmation: Bool = false
    
    var upcomingTasks: [MyTask] {
        tasks
            .filter { !$0.completed }
            .sorted { $0.dueTime < $1.dueTime }
    }
    
    var completedTasks: [MyTask] {
        tasks.filter { $0.completed }
            .sorted { $0.dueTime < $1.dueTime }
    }
    
    func toggleConfirm(task: MyTask) {
        showConfirmation = true
        selectedTask = task
    }
    
    func markAsCompleted(task: MyTask) {
        withAnimation {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                numTasksDone += tasks[index].completed ? -1:1
                tasks[index].dateCompletedAt = Date.now
                tasks[index].completed.toggle()
            }
                
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
