//
//  AddTaskView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var dueTime: Date = Date()

    @State private var petNames = ["Jupiter", "Fishy", "Balto", "Polly"]
    @State private var selectedPet: String = "Jupiter"
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                
                TextField("Task Name", text: $taskName)
                TextField("Task Description", text: $taskDescription)
                
                Picker("Select Pet", selection: $selectedPet) {
                    ForEach(petManager.pets) {pet in
                        Text(pet.name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                DatePicker("Due Date", selection: $dueTime, displayedComponents: [.date, .hourAndMinute])
            }
            Section {
                Button("Save Task") {
                    let newTask = MyTask(
                        name: taskName,
                        description: taskDescription,
                        pet: selectedPet,
                        dueTime: dueTime
                    )
                    taskManager.tasks.append(newTask)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(taskName.isEmpty)
            }
        }
        .navigationTitle("Add Task")
    }
}
