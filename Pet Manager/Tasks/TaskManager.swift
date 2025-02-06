//
//  TaskManager.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI
import UserNotifications
import SwiftData

class TaskManager: ObservableObject {
    
    func markAsCompleted(task: TaskItem) {
        withAnimation {
            task.completed.toggle()
        }
                
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
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
    
    func scheduleNotification(for task: TaskItem) {
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
    
    func updateNotification(for task: TaskItem) {
        deleteNotification(for: task)
        scheduleNotification(for: task)
    }
    
    func deleteNotification(for task: TaskItem) {
        let notificationID = task.id.uuidString
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])   
    }

}
