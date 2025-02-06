//
//  EditPetView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/28/25.
//

import Foundation
import SwiftUI
import SwiftData

struct EditPetView: View {
    @Bindable var pet: MyPet
    @Query var pets: [MyPet]
    
    @State var tempName: String
    @State private var isButtonVisible: Bool = false
    @State private var showDuplicateAlert: Bool = false
    @State private var nameWasChanged: Bool = false
    
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    
     func canEditPet() -> Bool {
         let isDuplicate = pets.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == tempName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
         
         let isEmpty = tempName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().isEmpty
         
         return (tempName != pet.name) && !isDuplicate && !isEmpty
     }
     
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header: Text("Change Pet Name").font(.system(size: 18))) {
                        CustomInputField(text: $tempName, placeholder: "", isFocused: $isFocused, isBgVisible: true)
                            .onChange(of: tempName) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    
                                    showDuplicateAlert = pets.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == tempName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
                                    isButtonVisible = canEditPet()
                                    nameWasChanged = tempName != pet.name
                                }
                            }
                            .onAppear { isFocused = true }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 150)
                
                VStack (alignment:.leading, spacing:0){
                    HStack (spacing: 0) {
                        Text("Current name is ")
                            .font(.system(size: 16, weight: .regular))
                        Text("\(pet.name)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 30)
                    
                    if nameWasChanged && showDuplicateAlert {
                        VStack (alignment: .leading) {
                            HStack (spacing: 0) {
                                Text("\(tempName.trimmingCharacters(in: .whitespacesAndNewlines)) ")
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
                            HStack (spacing: 0) {
                                Text("New name is ")
                                    .font(.system(size: 16, weight: .regular))
                                
                                Text("\(tempName)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.accentColor)
                            }
                            .transition(.move(edge:.bottom).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 50, alignment: .top)
                .padding(.leading, 40)
                
                VStack {
                    if isButtonVisible {
                        Button(action : {
                            // submits current text field input
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            
                            if canEditPet() {
                                if let index = pets.firstIndex(where: { $0.name == pet.name }) {
                                    pets[index].name = tempName
                                }
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
                                
                                
                                Text("Edit Pet")
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
                .frame(maxWidth: .infinity, maxHeight: 80)
                .padding(.top, 40)

            }
            .onAppear { tempName = pet.name }
            .frame(maxWidth: .none, maxHeight: geometry.safeAreaInsets.top, alignment: .top)
            .navigationTitle("Edit Pet")
        }
        .background(Color(UIColor.systemBackground))
        
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: MyPet.self, configurations: config)
//        
//        return EditPetView(pet: MyPet(name: "Pepper"), tempName: "Pepper")
//            .environmentObject(TaskManager())
//          //  .environmentObject(PetManager())
//            .environmentObject(SettingsManager())
//            .modelContainer(container)
//    } catch {
//        fatalError("Failed to create model container")
//    }
//}
//
