//
//  TasksListItem.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct TaskListItemView: View {
    @ObservedObject var task: MyTask
    let isPreview: Bool

    var body: some View {
        ZStack {
            if isPreview {
        
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(20), radius: 2, x: 0, y: 2)
                    
                    HStack {
                        TaskDetailsLeftView(task: task, isPreview: isPreview)
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
                NavigationLink(destination: EditTaskView(task: task)) {
                    HStack {
                        TaskDetailsLeftView(task: task, isPreview: isPreview)
                        Spacer()
                        TaskDetailsRightView(task: task)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
  AddTaskView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
        .environmentObject(SettingsManager())
}


struct TaskDetailsLeftView: View {
    @EnvironmentObject var taskManager: TaskManager
    
    @ObservedObject var task: MyTask
    let isPreview: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(task.name)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.accentColor)
            
            Text(task.description)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(UIColor.systemGray))
            
            Spacer()
            
            if !isPreview {
                Button(action: { taskManager.markAsCompleted(task: task) }) {
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
    @ObservedObject var task: MyTask
    
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
                    .foregroundColor(Color.accentColor) 
                
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
                    .foregroundColor(Color.accentColor)
                
                
            }
            
            HStack {
                Spacer()
                Text("\(task.pet.name)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                Image(systemName:  task.completed ? "pawprint.fill" : "pawprint")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14)
                    .foregroundColor(Color.accentColor)
                
            }
        }
        .frame(width: 100, height: 80)
    }
}

