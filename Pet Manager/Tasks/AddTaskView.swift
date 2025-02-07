//
//  AddTaskView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import Foundation
import SwiftUI
import SwiftData

struct AddTaskView: View {
    @State private var isButtonVisible: Bool = false
    @State private var isButtonEnabled: Bool = false
    
    let pets: [MyPet]
    let tasks: [TaskItem]
    
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

    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    
    @State private var showDetails = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDescriptionFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header:Text("Task Details").font(.system(size: 18))) {
                        CustomInputField(
                            text: $tempName,
                            placeholder: "Task Name",
                            isFocused: $isNameFocused,
                            isBgVisible: false)
                        .onChange(of: tempName.isEmpty) {
                            isButtonEnabled.toggle()
                            withAnimation(.easeOut(duration: 0.4)) {
                                isButtonVisible.toggle()
                            }
                        }
                        .onAppear { isNameFocused = true }
                        .padding(.top, 10)
                        
                        CustomInputField(
                            text: $tempDescr,
                            placeholder: "Task Description",
                            isFocused: $isDescriptionFocused,
                            isBgVisible: false)
                        
                        Picker("Select Pet", selection: $tempPet) {
                            ForEach(pets) {pet in
                                Text(pet.name).tag(pet)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        DatePicker("Due Date", selection: $tempDueTime, displayedComponents: [.date, .hourAndMinute])
                            .padding(.bottom, 10)
                        
                    }
                    .listRowSeparator(.hidden)
                   
                    VStack {
                        if isButtonVisible {

                            TaskListItemView(task: previewTask, pets: pets, tasks: tasks, isPreview: true)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            
                            Button(action : {
                                // submits current text field input
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                let newTask = TaskItem(
                                    id: UUID(),
                                    name: tempName,
                                    descr: tempDescr,
                                    dueTime: tempDueTime,
                                    completed: false,
                                    pet: tempPet
                                )
          
                                modelContext.insert(newTask)
                                
                                taskManager.checkNotificationPermission {
                                    isAuthorized in
                                    if isAuthorized {
                                        taskManager.scheduleNotification(for: newTask)
                                    }
                                }
                                taskManager.printPendingNotifications()
                                
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
                            .disabled(!isButtonEnabled)
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
            .navigationTitle("Add Task")
            .background(Color(UIColor.systemBackground))
        }
           
            
    }
}

//
//#Preview {
//    SwiftDataViewer(preview: PreviewContainer([MyPet.self, TaskItem.self]),
//                    items: [MyPet(name: "Test Guy")]) {
//        AddTaskView()
//            .environmentObject(TaskManager())
//            .environmentObject(PetManager())
//    }
//}
