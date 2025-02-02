//
//  TasksList.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct TasksList:View {
    @EnvironmentObject var taskManager: TaskManager
    
    func removeTask(at offsets: IndexSet) {
        for index in offsets {
            let task = taskManager.tasks[index]
            taskManager.deleteNotification(for: task)
        }
        taskManager.tasks.remove(atOffsets: offsets)
    }
                 
    var body: some View {
 
        List {
                if !taskManager.tasks.isEmpty {
                    Section(header: Text("Upcoming Tasks")
                        .font(.system(size: 18))
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 20).padding(.bottom, 10))
                    {
                        ForEach(taskManager.tasks, id:\.id) { task in
                            TaskListItemView(task: task, isPreview: false)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: removeTask)
                    }
                }

            
            if !taskManager.completedTasks.isEmpty {
                Section(header: Text("Completed Tasks")
                    .font(.system(size: 18)))
                {
                    ForEach(taskManager.completedTasks, id:\.id) { task in
                        TaskListItemView(task: task, isPreview: false)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: removeTask)
                }
            }
        }
       .animation(.easeInOut, value: taskManager.tasks)
       .listRowInsets(EdgeInsets())
       .listRowSpacing(16)
    }
}


#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

