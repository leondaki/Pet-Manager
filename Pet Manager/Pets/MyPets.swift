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
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \TaskItem.pet) var tasks: [TaskItem]
    
    init(name: String, tasks: [TaskItem] = []) {
        self.id = UUID()
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
                        VStack (alignment: .leading, spacing: 0)  {
                            Text("Pets")
                                .font(.system(size: 34, weight: .bold))
                                .padding(.bottom, 6)
                            
                            HStack (spacing: 0) {
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .padding(.trailing, 8)
                                
                                Text("You have ")
                                    .font(.system(size: 20, weight: .regular))
                                
                                Text("\(pets.count)")
                                    .contentTransition(.numericText(value: Double(pets.count)))
                                    .animation(.easeOut, value: pets.count)
                                    .font(.system(size: 20, weight: .regular))
                                
                                Text(pets.count == 1 ? " pet" : " pets")
                                    .font(.system(size: 20, weight: .regular))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                    .zIndex(1)
                
                if pets.count > 0 {
                    PetsList(pets: pets)
                }
                else {
                    Spacer()
                    VStack {
                        Text("Add a pet to create tasks!")
                            .font(.system(size: 20, weight: .regular))
                            .padding()
                        
                        NavigationLink(destination: AnyView(AddPetsView(pets: pets)))
                        {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .foregroundStyle(Color(settingsManager.selectedAccentColor))
                                .background(Circle().fill(.white))
                        }
                       
                    }
                 
                    Spacer()
                }
                    
            }
            .background(Color(UIColor.secondarySystemBackground))
        }

    }
}

struct PetsList:View {
   // @EnvironmentObject var petManager: PetManager
    @State private var swipedRow: UUID? = nil
    
    @State private var isConfirmVisible: Bool = false
    @State private var petToDelete: MyPet?
    
    let pets : [MyPet]
    @Environment(\.modelContext) private var modelContext
    
    // used to trigger pet deletion animation
    @State var petDeleted:Bool = false
    
    private func confirmDelete(pet: MyPet) {
        petToDelete = pet
        isConfirmVisible = true
    }
    
    var petToDeleteName: String {
        if let pet = petToDelete {
            return pet.name
        }
        return "this task"
    }
    
    func deletePet(pet: MyPet?) {
      if let petToDelete = pet {
          withAnimation {
              petDeleted = true
              modelContext.delete(petToDelete)
          }
          petDeleted = false
      }
    }

    var body: some View {
        List {
            ForEach(pets, id:\.id) { pet in
                PetRowView(pet: pet)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(action: {
                                confirmDelete(pet: pet)
                            }, label: {
                                Image(systemName: "trash.fill")
                                    .tint(Color.red)
                            })
                    }
            }
            
        }
        .listRowSpacing(16)
        .animation(.easeInOut, value: petDeleted)
        .confirmationDialog("This will also delete all tasks for \(petToDeleteName).",
                            isPresented: $isConfirmVisible, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deletePet(pet: petToDelete ?? nil)
             }
            Button("Cancel", role: .cancel) {
                petToDelete = nil // Reset selection if canceled
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

