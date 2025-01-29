//
//  TaskManager.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @EnvironmentObject var petManager: PetManager
    
    @Published var tasks: [MyTask] = [
        MyTask(
        name: "Feed Jupiter",
        description: "nanananana",
        pet: Pet(name: "Jupiter"),
        completed: false,
        dueTime: Date.now),
      MyTask(
          name: "Clean LitterBox",
          description: "oh lalaaaa",
          pet: Pet(name: "Rex"),
          completed: false,
          dueTime: Date.now.addingTimeInterval(10 * 60)),
      MyTask(
          name: "Lock Door",
          description: "click click",
          pet: Pet(name: "Ace"),
          completed: false,
          dueTime: Date.now.addingTimeInterval(30 * 60))]
    
    @Published var completedTasks: [MyTask] = []
    
    @Published var selectedTask: MyTask? = MyTask(
        name: "Feed Jupiter",
        description: "Only half a can per serving!",
        pet: Pet(name: "JJoey"),
        completed: false,
        dueTime: Date().addingTimeInterval(60*60)
    )
    
    @Published var showConfirmation: Bool = false
    
    func toggleConfirm(task: MyTask) {
        showConfirmation = true
        selectedTask = task
    }
    
    func markAsCompleted(task: MyTask) {
        withAnimation {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index].completed.toggle()
                tasks[index].dateCompletedAt = Date.now
                
                completedTasks.append(contentsOf: tasks.filter{ $0.completed })
                completedTasks.sort { $0.dueTime < $1.dueTime }
                tasks.remove(at: index)
            }
            else if let index = completedTasks.firstIndex(where: { $0.id == task.id }) {
                completedTasks[index].completed.toggle()
                completedTasks[index].dateCompletedAt = Date.now
                
                tasks.append(contentsOf:completedTasks.filter{ !$0.completed })
                tasks.sort { $0.dueTime < $1.dueTime }
                completedTasks.remove(at: index)
            }
                
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
