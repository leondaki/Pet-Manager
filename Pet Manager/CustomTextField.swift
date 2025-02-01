//
//  CustomTextField.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/25/25.
//

import Foundation
import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    var placeholder: String
    
    @FocusState.Binding var isFocused: Bool
  
    var activeColor: Color = Color.accentColor
    var inactiveColor: Color = Color.gray

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? activeColor : inactiveColor, lineWidth: 2)
                    .animation(.easeOut(duration: 0.1), value: isFocused)
            )
            .onTapGesture {
                isFocused = true
            }
            .focused($isFocused)
    }
}

#Preview {
   AddTaskView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
