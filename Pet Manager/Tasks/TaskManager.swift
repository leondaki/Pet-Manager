//
//  TaskManager.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI
import UserNotifications

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
        //showConfirmation = true
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
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void)  {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    completion(true)
                }
            }
        }
    }
    
    func scheduleNotification(for task: MyTask) {
        let notificationID = task.id.uuidString
        let deadline = task.dueTime
        let content = UNMutableNotificationContent()
        
        content.title = "Task Reminder"
        content.body = "Your task \"\(task.name)\" is due soon!"
        content.sound = .default

        // Trigger 0 minutes before the deadline
        let triggerDate = Calendar.current.date(byAdding: .minute, value: 0, to: deadline) ?? deadline
        let triggerComponents = Calendar.current.dateComponents(
              [.year, .month, .day, .hour, .minute],
              from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current // Apply local timezone
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                
                print("Notification scheduled for \(task.name) at \(formatter.string(from: triggerDate))")
            }
        }
    }
    
    func updateNotification(for task: MyTask) {
        deleteNotification(for: task)
        scheduleNotification(for: task)
    }
    
    func deleteNotification(for task: MyTask) {
        let notificationID = task.id.uuidString
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])   
    }

}
