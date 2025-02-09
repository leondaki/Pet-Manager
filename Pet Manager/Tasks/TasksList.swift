//
//  TasksList.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct TasksList:View {
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var isConfirmVisible: Bool = false
    @State private var taskToDelete: TaskItem?
    
    var tasks: [TaskItem]
    let pets: [MyPet]

    @Environment(\.modelContext) private var modelContext
    
    var taskToDeleteName: String {
        if let task = taskToDelete {
            return task.name
        }
        return "this task"
    }
    
    private func confirmDelete(task: TaskItem) {
        taskToDelete = task
        isConfirmVisible = true
    }
    
    // used to trigger task deletion animation
    @State private var deletedTask: Bool = false
    
    func deleteTask(task: TaskItem?) {
      if let taskToDelete = task {
          withAnimation {
              deletedTask = true
              modelContext.delete(taskToDelete)
              taskManager.deleteNotification(for: taskToDelete)
          }
         deletedTask = false
      }
    }

                 
    var completedTasks: [TaskItem] {
        return tasks.filter{ $0.completed }
    }
    
    var incompletedTasks: [TaskItem] {
        return tasks.filter{ !$0.completed }
    }
    
    var body: some View {
        List {
            if tasks.filter({ !$0.completed }).count == 0 {
                HStack {
                    Image(systemName: "party.popper.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color.gray)
                    
                    Text("All done for now!")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.gray)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
                
            if !incompletedTasks.isEmpty {
                    Section(header: Text("Upcoming Tasks")
                        .font(.system(size: 18))
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 20).padding(.bottom, 10))
                    {
                        ForEach(incompletedTasks, id:\.id) { task in
                            TaskListItemView(task: task, pets: pets, tasks: tasks, isPreview: false)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(action: {
                                            confirmDelete(task: task)
                                        }, label: {
                                            Image(systemName: "trash.fill")
                                                .tint(Color.red)
                                        }
                                        )
                                    }
                            
                                
                        }
                    }
                }

            
            if !completedTasks.isEmpty {
                Section(header: Text("Completed Tasks")
                    .font(.system(size: 18))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 20).padding(.bottom, 10))
                {
                    ForEach(completedTasks, id:\.id) { task in
                        TaskListItemView(task: task, pets: pets, tasks: tasks, isPreview: false)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(action: {
                                        confirmDelete(task: task)
                                    }, label: {
                                        Image(systemName: "trash.fill")
                                            .tint(Color.red)
                                    })
                                }
                        }
                }
           
            }
        }
        .animation(.easeInOut, value: deletedTask)
       .listRowInsets(EdgeInsets())
       .listRowSpacing(16)
       .confirmationDialog("Delete \(taskToDeleteName)?",
                           isPresented: $isConfirmVisible, titleVisibility: .visible) {
           Button("Delete", role: .destructive) {
               deleteTask(task: taskToDelete ?? nil)
            }
           Button("Cancel", role: .cancel) {
              taskToDelete = nil
           }
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(TaskManager())
//        .environmentObject(SettingsManager())
//}

