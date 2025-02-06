//
//  AddPetsView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI
import SwiftData

struct AddPetsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
  
    let pets : [MyPet]
    
    @State private var name = ""
    @State private var showDuplicateAlert: Bool = false
    @State private var isButtonVisible: Bool = false
    
    @FocusState private var isFocused: Bool

    func canAddPet() -> Bool {
        let isDuplicate = pets.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
        
        let isEmpty = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().isEmpty
        
        return !isDuplicate && !isEmpty
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) { 
                Form {
                    Section(header: Text("Pet Name").font(.system(size: 18))) {
                        CustomInputField(text: $name, placeholder: "Name", isFocused: $isFocused, isBgVisible: true)
                            .onChange(of: name) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showDuplicateAlert = pets.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
                                    isButtonVisible = canAddPet()
                                }
                            }
                            .onAppear { isFocused = true }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                 
                    }
                }
                .scrollContentBackground(.hidden)
               .frame(height: 150)
                
                VStack {
                    if showDuplicateAlert {
                        VStack (alignment: .leading) {
                            HStack (spacing: 0) {
                                Text("\(name.trimmingCharacters(in: .whitespacesAndNewlines)) ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("already exists!")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                            Text("Please choose a different name.")
                                .font(.system(size: 16))
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    else if isButtonVisible {
                        VStack {
                            HStack (spacing: 0) {
                                Text("Will be added as ")
                                    .font(.system(size: 16, weight: .regular))
                                
                                Text("\(name)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(height: 60, alignment: .top)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                
                if isButtonVisible {
                    Button(action : {
                        // submits current text field input
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                      if canAddPet() {
                           let newPet = MyPet(name: name)
                           modelContext.insert(newPet)
                           presentationMode.wrappedValue.dismiss()
                      }
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
                                      
                            Text("Add Pet")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color.accentColor)
                        }
                                        
                    }
                    .disabled(!isButtonVisible)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundStyle(Color.black)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .none, maxHeight: geometry.safeAreaInsets.top, alignment: .top)
            .navigationTitle("Add Pet")
        }
        
    }
   
}
//
//#Preview {
//    AddPetsView(, pets: <#[MyPet]#>)
//        .environmentObject(TaskManager())
//       // .environmentObject(PetManager())
//        
//}
//
