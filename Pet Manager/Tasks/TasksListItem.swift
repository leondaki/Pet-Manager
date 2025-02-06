//
//  TasksListItem.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TaskListItemView: View {
    @Bindable var task: TaskItem
    let pets: [MyPet]
    let tasks: [TaskItem]
    let isPreview: Bool

    var body: some View {
        ZStack {
            if isPreview {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(20), radius: 2, x: 0, y: 2)
                    
                    HStack {
                        TaskDetailsLeftView(tasks: tasks, task: task, isPreview: isPreview)
                        Spacer()
                        TaskDetailsRightView(task: task)
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                }
                .padding(.bottom, 10)
                .padding(.leading, 2)
                .padding(.trailing, 2)
               
            }
            
            else {
                NavigationLink(destination: EditTaskView(task: task, pets: pets, tasks: tasks, tempPet: pets[0])) {
                    HStack {
                        TaskDetailsLeftView(tasks: tasks, task: task, isPreview: isPreview)
                        Spacer()
                        TaskDetailsRightView(task: task)
                    }
                    .padding()
                }
            }
        }
    }
}

//#Preview {
//  TasksList()
//        .environmentObject(TaskManager())
//        .environmentObject(SettingsManager())
//}


struct TaskDetailsLeftView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    let tasks: [TaskItem]
    let task: TaskItem
    let isPreview: Bool
    
    var body: some View {

        VStack (alignment: .leading) {
            ZStack (alignment: .leading)
            {
                Text(task.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(settingsManager.selectedAccentColor))
                
                if task.hasPassedDue && !task.completed && !isPreview {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.red)
                        .frame(width: 20)
                        .offset(x: -20, y: -12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(task.descr)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(UIColor.systemGray))
            
            Spacer()
            
            if !isPreview {
                Button(action: { print("TAPPED")
                    taskManager.markAsCompleted(task: task) }) {
                    Image(systemName: task.deco.taskImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
        }
        .frame(height: 80)

    }
}


struct TaskDetailsRightView: View {
    let task: TaskItem
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack (alignment: .trailing) {
            HStack {
                Spacer()
                Text(task.dueTime.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year(.twoDigits)))
                    .foregroundStyle(.gray)
                    .font(.system(size: 16, weight: .medium))
                
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(settingsManager.selectedAccentColor))
                
            }
            
            HStack {
                Spacer()
                Text(task.dueTime, style: .time)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray)
                
                Image(systemName: task.completed ? "clock.fill" : "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
                    .foregroundColor(Color(settingsManager.selectedAccentColor))
            }
            
            HStack {
                Spacer()
                Text("\(task.name)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                Image(systemName: task.completed ? "pawprint.fill" : "pawprint")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14)
                    .foregroundColor(Color(settingsManager.selectedAccentColor))
                
            }
        }
        .frame(width: 120, height: 80)
    }
}

