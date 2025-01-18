//
//  Task.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/13/25.
//

import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [MyTask] = [
        MyTask(
            name: "Feed Jupiter",
            description: "Only half a can per serving!",
            pet: "Jupiter",
            dueTime: Date.now
        ),
        MyTask(
            name: "Lock Cat Door",
            description: "Or in only mode if Jupiter can't be found...",
            pet: "Jupiter",
            dueTime: Date.now
        ),
        MyTask(
            name: "Feed Fishy",
            description: "Use the pellets on the counter",
            pet: "Fishy",
            dueTime: Date.now
        )
    ]
}

struct MyTask: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var pet: String
    var dueTime: Date
}

struct TasksListView:View {
    var body: some View {
        @EnvironmentObject var taskManager: TaskManager
        
        NavigationView {
            VStack {
                TasksList()
                
                NavigationLink(destination: AddTaskView()) {
                        Text("Add Task")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
            }
            .navigationTitle("Tasks List 📋") 
            
        }
        
    }
}

struct TasksList:View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        List {
            ForEach(taskManager.tasks) {
                task in
                HStack {
                    Text("Pic here")
                    
                    VStack (alignment: .leading) {
                        Text(task.name)
                            .font(Font.custom("TrendSansOne", size: 16))
                        Text(task.description)
                            .font(Font.custom("WorkSans-Regular", size: 14))
                            .padding([.bottom], 8)
                        Text("🐾 \(task.pet)")
                            .font(Font.custom("WorkSans-Regular", size: 16))
                        Text("⏰ \(task.dueTime.formatted(.dateTime.month().day().year().hour().minute()))")
                            .font(Font.custom("WorkSans-Regular", size: 16))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())

}
