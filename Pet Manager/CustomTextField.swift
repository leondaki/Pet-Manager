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
    
    var isFocused: Bool
  
    var activeColor: Color = Color.accentColor
    var inactiveColor: Color = Color.gray
    
    var isBgVisible: Bool
    var characterLimit: Int = 12
    
    var body: some View {
            TextField(placeholder, text: $text)
                .padding(16)
                .frame(height: 50)
                .background(
                    ZStack {
                        if isBgVisible {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .padding(-20)
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? activeColor : inactiveColor, lineWidth: 2)
                            .animation(.easeOut(duration: 0.1), value: isFocused)
                    }
                )
                .onChange(of: text) { _, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit)) // Truncate input
                    }
                }      
                .overlay {
                    // Character counter
                    Text("\(text.count)/\(characterLimit)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
    }
}

//#Preview {
//   AddTaskView()
//        .environmentObject(TaskManager())
//        .environmentObject(PetManager())
//}
