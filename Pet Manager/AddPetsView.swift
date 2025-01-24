//
//  AddPetsView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct AddPetsView: View {
    @State private var petName: String = ""
    
    @EnvironmentObject var petManager: PetManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Pet Name")) {
                
                TextField("Pet Name", text: $petName)
            }
            Section {
                Button("Save  Pet") {
                    let newPet = Pet (name: petName)
                    petManager.pets.append(newPet)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(petName.isEmpty)
            }
        }
        .navigationTitle("Add a Pet")
    }
}
