//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI
import SwiftData

protocol TaskType {
    var id: UUID { get }
    var name: String { get }
    var descr: String { get }
    var dueTime: Date { get }
    var completed: Bool { get }
    var dateCompletedAt: Date? { get }
    var pet: MyPet? { get }
    var notificationTimeRawValue: String { get }
}

struct PreviewTask: TaskType {
    var id: UUID = UUID()
    var name: String
    var descr: String
    var dueTime: Date
    var completed: Bool = false
    var dateCompletedAt: Date?
    var pet: MyPet? = nil
    var notificationTimeRawValue: String = "At time of event"
}

extension TaskItem {
    var notificationTime: NotificationTime {
         get { NotificationTime(rawValue: notificationTimeRawValue) ?? .atEvent }
         set { notificationTimeRawValue = newValue.rawValue }
     }
    
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
}

@Model
class TaskItem: TaskType {    
    var id: UUID
    var name: String
    var descr: String
    var dueTime: Date
    var completed: Bool
    var dateCompletedAt: Date? = nil
    var pet: MyPet? = nil
    var notificationTimeRawValue: String = "5 minutes before"

    init (
        id: UUID = UUID(),
        name: String,
        descr: String,
        dueTime: Date,
        completed: Bool,
        dateCompletedAt: Date? = nil,
        pet: MyPet? = nil,
        notificationTimeRawValue: String = "5 minutes before"
    ) {
        self.id = id
        self.name = name
        self.descr = descr
        self.dueTime = dueTime
        self.completed = completed
        self.dateCompletedAt = dateCompletedAt
        self.pet = pet
        self.notificationTimeRawValue = notificationTimeRawValue
    }
}
