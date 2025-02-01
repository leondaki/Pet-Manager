//
//  EditTaskView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/29/25.
//

import Foundation
import SwiftUI

struct EditTaskView: View {
    @ObservedObject var task: MyTask
    
    @StateObject var tempTask = MyTask(name: "",
                                       description: "",
                                       pet: Pet(name: "Default Pet"),
                                       completed: false,
                                       dueTime: Date.now.addingTimeInterval(30 * 60))
    
    @State private var showEditButton: Bool = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool
    
    @EnvironmentObject var petManager: PetManager
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header:Text("Task Details").font(.system(size: 18))) {
                        CustomInputField(
                            text: $tempTask.name,
                            placeholder: "Task Name",
                            isFocused: $isNameFocused)
                            .onAppear { isNameFocused = true }
                            .onChange(of: tempTask.name) {
                                withAnimation {
                                    showEditButton = tempTask.name != task.name && !tempTask.name.isEmpty }
                            }
                            .padding(.top, 10)
                        
                        CustomInputField(
                            text: $tempTask.description,
                            placeholder: "Task Description",
                            isFocused: $isDescriptionFocused)
                        .onChange(of: tempTask.description) {
                            withAnimation {
                                showEditButton = tempTask.description != task.description }
                        }
                        
                        Picker("Select Pet", selection: $tempTask.pet) {
                            ForEach(petManager.pets) {pet in
                                Text(pet.name).tag(pet)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: tempTask.pet) {
                            withAnimation {
                                showEditButton = tempTask.pet != task.pet }
                        }
                        
                        DatePicker("Due Date", selection: $tempTask.dueTime, displayedComponents: [.date, .hourAndMinute])
                            .padding(.bottom, 10)
                            .onChange(of: tempTask.dueTime) {
                                withAnimation {
                                    showEditButton = tempTask.dueTime != task.dueTime }
                            }
                        
                    }
                    .listRowSeparator(.hidden)
                    
                    VStack {
                        TaskListItemView(task: tempTask, isPreview: true)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .frame(height: 140, alignment: .top)
                    
                    VStack {
                        if showEditButton {
                            Button(action : {
                                if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                                    taskManager.tasks[index] = tempTask
                                }
                                taskManager.checkNotificationPermission {
                                    isAuthorized in
                                    if isAuthorized {
                                        taskManager.updateNotification(for: tempTask)
                                    }
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 60, weight: .bold))
                                        .background(
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 60, height: 60)
                                        )

                                    Text("Edit Task")
                                        .font(.system(size: 20, weight: .bold))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundStyle(Color.accentColor)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)

                }
           }
            .onAppear {
                tempTask.name = task.name
                tempTask.description = task.description
                tempTask.pet = task.pet
                tempTask.dueTime = task.dueTime
            }
            .navigationTitle("Edit Task")
        }
    }
}

#Preview {
    EditTaskView(task: TaskManager().tasks[0])
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
