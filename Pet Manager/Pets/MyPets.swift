//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/14/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class MyPet {
    // let id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \TaskItem.pet) var tasks: [TaskItem]
    
    init(name: String, tasks: [TaskItem] = []) {
        self.name = name
        self.tasks = tasks
    }
}

struct PetsListView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    let pets : [MyPet]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                Rectangle()
                    .fill(Color(UIColor.systemBackground))
                    .frame(height: 110)
                    .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                    .overlay {
                        VStack (alignment: .leading)  {
                            Text("Pets")
                                .font(.system(size: 34, weight: .bold))
                            HStack (spacing: 0) {
                                Text("You have ")
                                    .font(.system(size: 20, weight: .regular))
                                
                                Text("\(pets.count)")
                                    .contentTransition(.numericText(value: Double(pets.count)))
                                    .animation(.easeOut, value: pets.count)
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundStyle( Color(settingsManager.selectedAccentColor))
                                
                                Text(pets.count == 1 ? " pet." : " pets.")
                                    .font(.system(size: 20, weight: .regular))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                    .zIndex(1)
                
                PetsList(pets: pets)
                    
            }
            .background(Color(UIColor.secondarySystemBackground))
        }

    }
}

struct PetsList:View {
   // @EnvironmentObject var petManager: PetManager
    @State private var swipedRow: UUID? = nil
    
    @State private var isConfirmVisible: Bool = false
    @State private var petToDeleteIndex: IndexSet?
    
    let pets : [MyPet]
    @Environment(\.modelContext) private var modelContext
    
    private func confirmDelete(at offsets: IndexSet) {
        petToDeleteIndex = offsets
        isConfirmVisible = true
    }
    
    var petToDeleteName: String {
        if let index = petToDeleteIndex?.first {
            return pets[index].name
        }
        return "this pet"
    }
    
    func deletePets(_ indexSet: IndexSet) {
        for index in indexSet {
            let pet = pets[index]
            modelContext.delete(pet)
        }
        
        petToDeleteIndex = nil
    }
                         
    var body: some View {
        List {
            ForEach(pets) { pet in
                PetRowView(pet: pet)
            }
            .onDelete(perform: confirmDelete)
        }
        .confirmationDialog("This will also delete all tasks for \(petToDeleteName).",
                            isPresented: $isConfirmVisible, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deletePets(petToDeleteIndex ?? [])
             }
            Button("Cancel", role: .cancel) {
                petToDeleteIndex = nil // Reset selection if canceled
            }
         }
    }
}

struct PetRowView: View {
    var pet: MyPet
    
    var body: some View {
        ZStack {
            HStack {
                Text(pet.name)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
            }
            
            NavigationLink(destination: EditPetView(pet: pet, tempName: pet.name)) {} .opacity(0)
        }
        .padding()
    }
}

//#Preview {
//    PetsListView()
//        .environmentObject(TaskManager())
//       // .environmentObject(PetManager())
//        .environmentObject(SettingsManager())
//
//}

