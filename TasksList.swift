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
            LazyVStack (alignment: .leading) {
                if !taskManager.upcomingTasks.isEmpty {
                    Text("Upcoming Tasks")
                        .padding(.leading, 20)
                        .font(.system(size: 20, weight: .bold))

                    ForEach(taskManager.upcomingTasks, id:\.id) { task in
                        TaskListItemView(
                            taskItem: task,
                            itemTap: {
                                
                            }
                           )
                        .listRowSeparator(.hidden)
                    }
                }
                
                if !taskManager.completedTasks.isEmpty {
                    Text("Completed Tasks")
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        .font(.system(size: 20, weight: .bold))
                    
                    ForEach(taskManager.completedTasks, id:\.id) { task in
                        TaskListItemView(
                            taskItem: task,
                            itemTap: {
                                
                            } 
                        )
                        .listRowSeparator(.hidden) 
                    }
                }
            }
            .confirmationDialog("Task Options",
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
            //.background(Color(red: 1, green: 0.92, blue: 0.83))
            .animation(.easeInOut, value: taskManager.tasks)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

