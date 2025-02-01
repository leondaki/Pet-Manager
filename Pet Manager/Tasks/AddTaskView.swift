//
//  AddTaskView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @State private var showAddButton: Bool = false
    @StateObject private var newTask = MyTask(
        name: "",
        description: "",
        pet: Pet(name: "Default Pet"),
        completed: false,
        dueTime: Date.now.addingTimeInterval(30 * 60))
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDetails = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool
    
    var body: some View {
        if petManager.pets.count > 0 {
            GeometryReader { geometry in
                VStack (spacing: 0) {
                    Form {
                        Section(header:Text("Task Details").font(.system(size: 18))) {
                            CustomInputField(
                                text: $newTask.name,
                                placeholder: "Task Name",
                                isFocused: $isNameFocused)
                            .onChange(of: newTask.name.isEmpty) {
                                withAnimation(.easeOut(duration: 0.4)) {
                                    showAddButton.toggle()
                                }
                            }
                            .onAppear { isNameFocused = true }
                            .padding(.top, 10)
                            
                            CustomInputField(
                                text: $newTask.description,
                                placeholder: "Task Description",
                                isFocused: $isDescriptionFocused)
                            
                            Picker("Select Pet", selection: $newTask.pet) {
                                ForEach(petManager.pets) {pet in
                                    Text(pet.name).tag(pet)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            DatePicker("Due Date", selection: $newTask.dueTime, displayedComponents: [.date, .hourAndMinute])
                                .padding(.bottom, 10)
                            
                        }
                        .listRowSeparator(.hidden)
                       
                        VStack {
                            if showAddButton {
                                TaskListItemView(task: newTask, isPreview: true)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                
                                Button(action : {
                                    taskManager.tasks.append(newTask)
                                    taskManager.checkNotificationPermission {
                                        isAuthorized in
                                        if isAuthorized {
                                            taskManager.scheduleNotification(for: newTask)
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
                                            .foregroundStyle(Color.accentColor)
                                        
                                        Text("Add Task")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            
                            else {
                                Text("You must add a Task Name")
                                    .font(.system(size: 20))
                                    .italic()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .frame(height: 240, alignment: .top)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .onAppear { newTask.pet = petManager.pets[0] }
                .navigationTitle("Add Task")
                .background(Color(UIColor.systemBackground))
            }
           
            
        }
        else {
            VStack {
                Text("Please add at least one pet first!")
                    .font(.system(size: 20, weight: .regular))
                    .padding()
            }
            .navigationTitle("Add Task")
        }
    }
    
}

#Preview {
    AddTaskView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
