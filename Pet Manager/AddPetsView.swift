//
//  AddPetsView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct AddPetsView: View {
    @StateObject private var pet = Pet(name: "")
    @State private var showAddButton: Bool = false
    @FocusState private var isFocused: Bool
    
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack (spacing: 0) {
                Form {
                    Section(header: Text("Pet Name").font(.system(size: 18))) {
                        CustomInputField(text: $pet.name, placeholder: "Name", isFocused: $isFocused)
                            .onChange(of: pet.name.isEmpty) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showAddButton.toggle()
                                }
                            }
                            .onAppear { isFocused = true }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }
                }
                .frame(height: 150)
                
                
                VStack {
                    if showAddButton {
                        HStack {
                            Text("Will be added as ")
                            + Text("\(pet.name)")
                                .font(.system(size: 16, weight: .bold))
                        }
                       // .transition(.opacity))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                .padding(.leading, 40)
                
                VStack {
                    if showAddButton {
                        Button(action : {
                            petManager.pets.append(pet)
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
                                
                                
                                Text("Add Pet")
                                    .font(.system(size: 20, weight: .bold))
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
            .frame(maxWidth: .none, maxHeight: geometry.safeAreaInsets.top, alignment: .top)
            .navigationTitle("Add Pet")
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

#Preview {
    AddPetsView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
