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
    @FocusState private var isFocused: Bool

    var placeholder: String
    var activeColor: Color = .black
    var inactiveColor: Color = Color(UIColor.systemGray3)

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? activeColor : inactiveColor, lineWidth: 2)
                    .animation(.easeOut(duration: 0.1), value: isFocused)
            )
            .focused($isFocused)
    }
}

#Preview {
   AddTaskView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
