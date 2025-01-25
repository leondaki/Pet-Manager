//
//  TasksListItem.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct TaskListItemView: View {
    let taskItem: MyTask
    let itemTap: () -> Void
    
    @State var isTapped: Bool = false
    
    @EnvironmentObject var taskManager: TaskManager

    private func startBounceAnim() {
        isTapped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            isTapped = false
        }
    }
    
    var body: some View {
    RoundedRectangle(cornerRadius: 16)
        .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 2, y: 2)
        .frame(height: 110)
        .foregroundColor(taskItem.colors.taskBgColor)
        .overlay {
            HStack {
                VStack (alignment: .leading) {
                    Text(taskItem.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(taskItem.colors.taskImageColor)
                    
                    Text("for \(taskItem.pet)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(taskItem.colors.taskImageColor)
                    
                    Spacer()
                    
                    Image(systemName: taskItem.colors.taskImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                        .foregroundColor(taskItem.colors.taskImageColor)
                }
                .frame(height: 80)
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Label {
                        Text(taskItem.dueTime.formatted(.dateTime.month().day().year()))
                            .font(.system(size: 16, weight: .medium))
                    } icon: {
                        Image(systemName: taskItem.completed ? "calendar" : "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(.black)
                    }
                    
                    Label {
                        Text(taskItem.dueTime, style: .time)
                            .font(.system(size: 16, weight: .medium))
                    } icon: {
                        Image(systemName: taskItem.completed ? "clock.fill" : "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(.black)
                    }

                    Button(action: { taskManager.toggleConfirm(task: taskItem) }) {
                        Text(taskItem.completed ? "Incomplete" : "Complete")
                            .font(.system(size: 14, weight: .bold))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 16)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: 80)
            }
            .padding()
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .scaleEffect(isTapped ? 1.1 : 1.0) // Change scale on tap
        .animation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.2), value: isTapped)
        .onTapGesture {
            startBounceAnim()
            //itemTap() // Trigger the action passed from the parent view
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}


