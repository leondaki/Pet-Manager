//
//  CustomTextEditor.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 2/9/25.
//

import SwiftUI

struct CustomTextEditor: View {
    var isFocused: Bool
    @Binding var text: String
    
    var placeholder: String = "Enter description..."
        
    var activeColor: Color = Color.accentColor
    var inactiveColor: Color = Color.gray

    var characterLimit: Int = 12
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.systemGray3))
                    .padding(.vertical, 14) // Adjusts vertical alignment
                    .padding(.horizontal, 10)
            }

            TextEditor(text: $text)
                .frame(height: 200) // Adjust height as needed
                .padding(6) // Matches placeholder padding
                .background(RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? activeColor : inactiveColor, lineWidth: 2)
                    .animation(.easeOut(duration: 0.1), value: isFocused))
                .onChange(of: text) { _, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit)) // Truncate input
                    }
                }  
        }
        
    }
}
//
//#Preview {
//    CustomTextEditor()
//}
