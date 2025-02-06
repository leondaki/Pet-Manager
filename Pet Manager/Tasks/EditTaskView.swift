//
//  EditTaskView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/29/25.
//

import Foundation
import SwiftUI

struct EditTaskView: View {
    let task: TaskItem
    let pets: [MyPet]
    let tasks: [TaskItem]
    @Environment(\.modelContext) private var modelContext

    @State private var tempName = ""
    @State private var tempDescr = ""
    @State private var tempDueTime = Date.now
    @State var tempPet: MyPet
    
    var previewTask: PreviewTask {
        PreviewTask(
            name: tempName,
            descr: tempDescr,
            dueTime: tempDueTime,
            pet: tempPet
        )
    }
    
    @State private var showEditButton: Bool = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool

    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header: Text("Task Details").font(.system(size: 18))) {
                        CustomInputField (
                            text: $tempName,
                            placeholder: "Task Name",
                            isFocused: $isNameFocused, isBgVisible: false)
                            .onAppear { isNameFocused = true }
                            .onChange(of: tempName) {
                                withAnimation {
                                    showEditButton = tempName != task.name && !tempName.isEmpty }
                            }
                            .padding(.top, 10)
                        
                        CustomInputField(
                            text: $tempDescr,
                            placeholder: "Task Description",
                            isFocused: $isDescriptionFocused,
                            isBgVisible: false)
                        .onChange(of: tempDescr) {
                            withAnimation {
                                showEditButton = tempDescr != task.descr }
                        }
                        
                        Picker("Select Pet", selection: $tempPet) {
                            ForEach(pets) {pet in
                                Text(pet.name).tag(pet)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: tempPet) {
                            withAnimation {
                                showEditButton = tempPet != task.pet }
                        }
                        
                        DatePicker("Due Date", selection: $tempDueTime, displayedComponents: [.date, .hourAndMinute])
                            .padding(.bottom, 10)
                            .onChange(of: tempDueTime) {
                                withAnimation {
                                    showEditButton = tempDueTime != task.dueTime }
                            }
                        
                    }
                    .listRowSeparator(.hidden)
                    
                    VStack {
                        TaskListItemView(task: previewTask, pets: pets, tasks: tasks, isPreview: true)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .frame(height: 140, alignment: .top)
                    
                    VStack {
                        if showEditButton {
                            Button(action : {
                                // submits current text field input
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                task.name =  tempName
                                task.descr = tempDescr
                                task.dueTime = tempDueTime
                                task.pet = tempPet
                                
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Failed to Update Task: \(error)")
                                }
//                                if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
//                                    taskManager.tasks[index] = tempTask
//                                }
//                                taskManager.checkNotificationPermission {
//                                    isAuthorized in
//                                    if isAuthorized {
//                                        taskManager.updateNotification(for: tempTask)
//                                    }
//                                }
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
                tempName = task.name
                tempDescr = task.descr
                tempDueTime = task.dueTime
                tempPet = task.pet ?? MyPet(name: "Unnamed Pet")
            }
            .navigationTitle("Edit Task")
        }
    }
}
//
//#Preview {
//    EditTaskView(task: TaskManager().tasks[0])
//        .environmentObject(TaskManager())
//        .environmentObject(PetManager())
//}
