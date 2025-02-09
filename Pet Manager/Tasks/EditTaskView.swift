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
    @State private var selectedNotificationTime: NotificationTime = .fiveMinutes
    
    var previewTask: PreviewTask {
        PreviewTask(
            name: tempName,
            descr: tempDescr,
            dueTime: tempDueTime,
            pet: tempPet
        )
    }
    
    @State private var showEditButton: Bool = false
   
    @FocusState private var focusedField: Field?

    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header: Text("Task Details").font(.system(size: 18))) {
                        CustomInputField (
                            text: $tempName,
                            placeholder: "Task Name",
                            isFocused: focusedField == .name,
                            isBgVisible: false,
                            characterLimit: 20)
                        .focused($focusedField, equals: .name)
                        .onAppear { focusedField = .name }
                            .onChange(of: tempName) {
                                withAnimation {
                                    showEditButton = tempName != task.name && !tempName.isEmpty }
                            }
                            .padding(.top, 10)
                        
                        CustomTextEditor(
                            isFocused: focusedField == .description,
                            text: $tempDescr)
                        .focused($focusedField, equals: .description)
                        .onChange(of: tempDescr) {
                            withAnimation {
                                showEditButton = tempDescr != task.descr }
                        }
                        
//                        CustomInputField(
//                            text: $tempDescr,
//                            placeholder: "Task Description",
//                            isFocused: focusedField == .description,
//                            isBgVisible: false)
//                        .onChange(of: tempDescr) {
//                            withAnimation {
//                                showEditButton = tempDescr != task.descr }
//                        }
                        
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
                        
                        Picker("Notify Me", selection: $selectedNotificationTime) {
                            ForEach(NotificationTime.allCases, id:\.self) { time in
                                Text(time.rawValue).tag(time)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedNotificationTime) {
                            withAnimation {
                                showEditButton = selectedNotificationTime != task.notificationTime }
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
                                task.notificationTimeRawValue = selectedNotificationTime.rawValue
                                
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Failed to Update Task: \(error)")
                                }
                                
                                // update task notification
                                if settingsManager.notificationsEnabled {
                                    taskManager.updateNotification(for: task)
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
                tempName = task.name
                tempDescr = task.descr
                tempDueTime = task.dueTime
                tempPet = task.pet ?? MyPet(name: "Unnamed Pet")
                selectedNotificationTime = task.notificationTime
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
