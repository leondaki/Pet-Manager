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

enum NotificationTime: String, CaseIterable {
    case atEvent = "At time of event"
    case fiveMinutes = "5 minutes before"
    case thirtyMinutes = "30 minutes before"
    case oneHour = "1 hour before"
    case oneDay = "1 day before"
    
    var timeInterval: TimeInterval {
        switch self {
            case .atEvent: return 0  // at time of event
            case .fiveMinutes: return 5 * 60  // 5 minutes in seconds
            case .thirtyMinutes: return 30 * 60  // 30 minutes in seconds
            case .oneHour: return 60 * 60  // 1 hour in seconds
            case .oneDay: return 24 * 60 * 60  // 1 day in seconds
        }
    }
}

class TaskManager: ObservableObject {
    func toggleCompleted(task: TaskItem) {
        withAnimation {
            task.completed.toggle()
        }
                
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func printPendingNotifications() {
        print("Pending Notifications:\n")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("Notification ID: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                print("Trigger: \(String(describing: request.trigger))\n")
            }
        })
    }
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void)  {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                print("checking notification permissions...")
                if settings.authorizationStatus == .authorized {
                    print("authorized for notifs.")
                    completion(true)
                }
                else {
                    print("! NOT authorized for notifs!")
                    completion(false)
                }
            }
        }
    }
    
    func scheduleNotification(for task: TaskItem) {
        let notificationID = task.id.uuidString
        let deadline = task.dueTime
        let notificationTime = deadline.addingTimeInterval(-(task.notificationTime.timeInterval))
        
        let content = UNMutableNotificationContent()
        
        content.title = "Task Reminder"
        content.body = "Your task \"\(task.name)\" is due soon!"
        content.sound = .default

        let triggerComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: notificationTime
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
            else {
                print("Scheduled Notification for \(task.name)!")
            }
        }
    }
    
    func updateNotification(for task: TaskItem) {
        deleteNotification(for: task)
        scheduleNotification(for: task)
        
        print("Updated Notifcations:")
        printPendingNotifications()
    }
    
    func deleteNotification(for task: TaskItem) {
        let notificationID = task.id.uuidString
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
    }
}
