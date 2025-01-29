//
//  TasksListItem.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct TaskListItemView: View {
    @Binding var task: MyTask
    let isPreview: Bool
    //let itemTap: () -> Void
    
    @State var isTapped: Bool = false
    
    @EnvironmentObject var taskManager: TaskManager

    private func startBounceAnim() {
        isTapped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            isTapped = false
        }
    }
    
    var body: some View {
         Rectangle()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(height: 110)
            .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 2, y: 2)
            .foregroundColor(task.deco.taskBgColor)
        .overlay {
            HStack {
                VStack (alignment: .leading) {
                    Text(task.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(task.deco.taskImageColor)
                    
                    Text("for \(task.pet.name)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(task.deco.taskImageColor)
                    
                    Spacer()
                    
                    Image(systemName: task.deco.taskImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24)
                        .foregroundColor(task.deco.taskImageColor)
                }
                .frame(height: 80)

                
                Spacer()
                
                VStack (alignment: .trailing) {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(.black)
                        
                        Text(task.dueTime.formatted(.dateTime.month().day().year()))
                            .font(.system(size: 16, weight: .medium))

                       
                    }
                    
                    HStack {
                        Image(systemName: task.completed ? "clock.fill" : "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                            .foregroundColor(.black)
                        
                        Text(task.dueTime, style: .time)
                            .font(.system(size: 16, weight: .medium))
                        
                       
                    }
      
                    if !isPreview {
                        Button(action: { taskManager.toggleConfirm(task: task) }) {
                            Text(task.completed ? "Incomplete" : "Complete")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 16)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    else {
                        Spacer()
                    }
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
   AddTaskView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}


