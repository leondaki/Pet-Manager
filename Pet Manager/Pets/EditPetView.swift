//
//  EditPetView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/28/25.
//

import Foundation
import SwiftUI

struct EditPetView: View {
    @ObservedObject var pet: Pet
    
    @State var tempName: String
    @State private var showEditButton: Bool = false
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var petManager: PetManager
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header: Text("Change Pet Name").font(.system(size: 18))) {
                        CustomInputField(text: $tempName, placeholder: "", isFocused: $isFocused)
                            .onChange(of: tempName) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showEditButton = tempName != pet.name && !tempName.isEmpty
                                }
                            }
                            .onAppear { isFocused = true }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 150)
                
                VStack (alignment: .leading){
        
                    Text("Current name is ")
                        .font(.system(size: 16, weight: .regular))
                   + Text("\(pet.name)")
                        .font(.system(size: 16, weight: .bold))

                    if showEditButton {
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
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                .padding(.leading, 40)
                
                VStack {
                    if showEditButton {
                        Button(action : {
                            if let index = petManager.pets.firstIndex(where: { $0.name == pet.name }) {
                                petManager.pets[index].name = tempName
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
                                    .foregroundStyle(Color.accentColor)
                                
                                
                                Text("Edit Pet")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
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

#Preview {
    PetsListView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
