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
    @State private var taskToDeleteIndex: IndexSet?
    
    let tasks: [TaskItem]
    let pets: [MyPet]
    @Environment(\.modelContext) private var modelContext
    
    var taskToDeleteName: String {
        if let index = taskToDeleteIndex?.first {
            return tasks[index].name
        }
        return "this task"
    }
    
    private func confirmDelete(at offsets: IndexSet) {
        taskToDeleteIndex = offsets
        isConfirmVisible = true
    }
    
    func deleteTask(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            modelContext.delete(task)
        }
//        
//        if let indexSet = taskToDeleteIndex, let index = indexSet.first {
//            let task = tasks[index] // Extract task safely
//            
//            //taskManager.deleteNotification(for: task) // Remove notification
//            
//            modelContext.delete(task) // Remove task from list
//        }
//        
//        print("Stored color: \(UserDefaults.standard.string(forKey: "selectedAccentColor") ?? "default")")
        
        taskToDeleteIndex = nil // Reset after deletion
    }
                 
    var completedTasks: [TaskItem] {
        return tasks.filter{ $0.completed }
    }
    
    var incompletedTasks: [TaskItem] {
        return tasks.filter{ !$0.completed }
    }
    
    var body: some View {
        List {
            if !completedTasks.isEmpty {
                    Section(header: Text("Upcoming Tasks")
                        .font(.system(size: 18))
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 20).padding(.bottom, 10))
                    {
                        ForEach(completedTasks, id:\.id) { task in
                            TaskListItemView(task: task, pets: pets, tasks: tasks, isPreview: false)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: confirmDelete)
                    }
                }

            
            if !incompletedTasks.isEmpty {
                Section(header: Text("Completed Tasks")
                    .font(.system(size: 18))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 20).padding(.bottom, 10))
                {
                    ForEach(incompletedTasks, id:\.id) { task in
                        TaskListItemView(task: task, pets: pets, tasks: tasks, isPreview: false)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: confirmDelete)
                   
                }
            }
        }
       .animation(.easeInOut, value: tasks)
       .listRowInsets(EdgeInsets())
       .listRowSpacing(16)
       .confirmationDialog("Delete \(taskToDeleteName)?",
                           isPresented: $isConfirmVisible, titleVisibility: .visible) {
           Button("Delete", role: .destructive) {
               deleteTask(taskToDeleteIndex ?? [])
            }
           Button("Cancel", role: .cancel) {
               taskToDeleteIndex = nil // Reset selection if canceled
           }
        }
    }
}

//#Preview {
//    ContentView()
//        .environmentObject(TaskManager())
//        .environmentObject(SettingsManager())
//}

