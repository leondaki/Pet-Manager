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
    @StateObject private var newTask = MyTask(name: "", description: "", pet: "", dueTime: Date.now)
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDetails = false
    var body: some View {
        if petManager.pets.count > 0 {
            VStack {
                Form {
                    Section(header:
                        Text("Task Details")
                            .font(.system(size: 18))
                    ) {
                        CustomInputField(text: $newTask.name, placeholder: "Task Name")
                            .onChange(of: newTask.name.isEmpty) {
                                withAnimation {
                                    showAddButton.toggle()
                                }
                            }
                        
                        CustomInputField(text: $newTask.description, placeholder: "Task Description")
                        
                        Picker("Select Pet", selection: $newTask.pet) {
                            ForEach(petManager.pets) {pet in
                                Text(pet.name).tag(pet.name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        DatePicker("Due Date", selection: $newTask.dueTime, displayedComponents: [.date, .hourAndMinute])
                        
                    }
                    .listRowSeparator(.hidden)
                    
                    VStack {
                        if showAddButton {
                            TaskListItemView(task: newTask, isPreview: true)
                                .transition(.move(edge: .top))
                            
                            Button(action : {
                                taskManager.tasks.append(newTask)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 60, weight: .bold))
                                    
                                    Text("Add Task")
                                        .font(.system(size: 20, weight: showAddButton ? .bold : .regular))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundStyle(Color.black)
                            .transition(.move(edge: .bottom))
                        }
                        else {
                            Text("You must add a Task Name!")
                                .font(.system(size: 20, weight: showAddButton ? .bold : .regular))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .animation(.easeOut(duration: 0.3), value: showAddButton)
                    .listRowInsets(EdgeInsets())
                    
                }
                .scrollContentBackground(.hidden)

            }
            .onAppear { newTask.pet = petManager.pets[0].name }
            .navigationTitle("Add Task")
           
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
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
