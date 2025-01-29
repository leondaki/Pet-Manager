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
    
    var body: some View {
        ScrollView {
            LazyVStack ( alignment: .leading) {
                if !taskManager.tasks.isEmpty {
                    Text("Upcoming Tasks")
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .font(.system(size: 20, weight: .bold))

                    ForEach(taskManager.tasks, id:\.id) { task in
                        TaskListItemView(task: task, isPreview: false)
                            .listRowSeparator(.hidden)
                    }
                }
                
                if !taskManager.completedTasks.isEmpty {
                    Text("Completed Tasks")
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        .font(.system(size: 20, weight: .bold))
                    
                    ForEach(taskManager.completedTasks, id:\.id) { task in
                        TaskListItemView(task: task, isPreview: false)
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .confirmationDialog("Complete Task",
                                isPresented: $taskManager.showConfirmation,
                                actions: {
                if let tappedTask = taskManager.selectedTask {
                    Button(tappedTask.completed ? "Mark as Incomplete": "Mark as Complete",
                        action: {
                            taskManager.markAsCompleted(task: tappedTask)
                        }
                    )
                }
                Button("Cancel", role: .cancel) {}
            })
            .animation(.easeInOut, value: taskManager.tasks)
        }
    }
       
}


#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

