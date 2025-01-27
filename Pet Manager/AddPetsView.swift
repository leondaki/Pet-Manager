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
    
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Pet Name")) {
                //TextField("Pet Name", text: $pet.name)
                CustomInputField(text: $pet.name, placeholder: "Name")
                    .onChange(of: pet.name.isEmpty) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showAddButton.toggle()
                        }
                    }
                
                VStack {
                    if showAddButton {
                        HStack {
                            Text("Will be added as ")
                            + Text("\(pet.name)")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }.listRowSeparator(.hidden)
            }

            VStack {
                if showAddButton {
                    Button(action : {
                        petManager.pets.append(pet)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60, weight: .bold))
                            
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
           
        }
        
        .scrollContentBackground(.hidden)
        .navigationTitle("Add a Pet")
    }
}

#Preview {
    AddPetsView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
