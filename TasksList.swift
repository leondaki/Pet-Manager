//
//  TasksList.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct TasksListView:View {
    @State private var showConfirmation: Bool = false
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
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

struct TaskListItemView: View {
    let taskItem: MyTask
    let onTap: () -> Void
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        HStack {
//            HStack {
//                RoundedRectangle(cornerRadius: 4)
//                    .offset(x: -16)
//                    .fill(taskItem.colors.taskImageColor)
//                    .frame(width: 4, height: 20)
//            }
//            .frame(width: 4, height: 44, alignment: .top)

            VStack (alignment: .leading) {
                Text(taskItem.name)
                    .font(.headline)
                    .foregroundColor(taskItem.colors.taskImageColor)
                
                Text("for \(taskItem.pet)")
                    .italic()
                    .fontWeight(.light)
                
            }
//                HStack {
//                    Image(systemName: taskItem.colors.taskImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20)
//                        .foregroundColor(taskItem.colors.taskImageColor)
//                }
//                .frame(width: 30, height: 44, alignment: .top)
                
                HStack {
                    Spacer()
                    Label {
                        Text(taskItem.dueTime, style: .time)
                            .font(Font.custom("WorkSans-Regular", size: 16))
                    } icon: {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .offset(x: 10)
                            .foregroundColor(.black)
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(taskItem.colors.taskBgColor)
        .listRowBackground(Color.clear)
        .onTapGesture {
            onTap()
        }
    }
}

struct TasksList:View {
    @EnvironmentObject var taskManager: TaskManager
    
    private func markAsCompleted(task: MyTask) {
        withAnimation {
            if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                taskManager.completedTasks += taskManager.tasks[index].completed ? -1:1
                taskManager.tasks[index].completed.toggle()
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Upcoming Tasks").padding(.horizontal, -16)) {
                ForEach(taskManager.tasks
                    .filter { !$0.completed }
                    .sorted { $0.dueTime < $1.dueTime }
                ) { task in
                    TaskListItemView(taskItem: task) {
                        taskManager.showConfirmation = true
                        taskManager.selectedTask = task
                    }
                        
                }
               
            }
            
            
            Section(header: Text("Completed Tasks").padding(.horizontal, -16)) {
                ForEach(taskManager.tasks
                    .filter { $0.completed }
                    .sorted { $0.dueTime < $1.dueTime }
                ) { task in
                    TaskListItemView(taskItem: task) {
                        taskManager.showConfirmation = true
                        taskManager.selectedTask = task
                    }
                }
            }
        }
        .confirmationDialog("Task Options",
                            isPresented: $taskManager.showConfirmation,
                            actions: {
            if let tappedTask = taskManager.selectedTask {
                Button(
                    tappedTask.completed ? "Mark as Incomplete": "Mark as Complete",
                    action: {
                        withAnimation {
                            markAsCompleted(task: tappedTask)
                        }
                    }
                )
            }
            Button("Cancel", role: .cancel) {}
        })
        .listRowSpacing(10)
        .scrollContentBackground(.hidden)
        //.background(Color(red: 1, green: 0.92, blue: 0.83))
        .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 2, y: 2)
        .animation(.easeInOut, value: taskManager.tasks)
    }
}


#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

