//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/14/25.
//

import Foundation
import SwiftUI

class Pet: Identifiable, ObservableObject, Hashable, Equatable {
    static func == (lhs:Pet, rhs:Pet) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    @Published var name: String
    
    init(name: String) {
        self.name = name
    }
}

class PetManager: ObservableObject {
    @Published var pets: [Pet] = [
        Pet(name: "JJoey"),
        Pet(name: "Ace"),
        Pet(name: "Rex")
    ]
    
    func deletePet(_ pet: Pet) {
        withAnimation {
            if let index = pets.firstIndex(where: { $0.id == pet.id }) {
                pets.remove(at: index)
                
            }
        }
    }
}

struct PetsListView: View {
    @EnvironmentObject var petManager: PetManager

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
                                
                                Text("\(petManager.pets.count)")
                                    .contentTransition(.numericText(value: Double(petManager.pets.count)))
                                    .animation(.easeOut, value: petManager.pets.count)
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundStyle(Color.accentColor)
                                
                                Text(petManager.pets.count == 1 ? " pet." : " pets.")
                                    .font(.system(size: 20, weight: .regular))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                    .zIndex(1)
                
                PetsList()
            }
            .background(Color(UIColor.secondarySystemBackground))
        }

    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    @State private var swipedRow: UUID? = nil
    
    func removeRow(at offsets: IndexSet) {
        petManager.pets.remove(atOffsets: offsets)
    }
                              
    var body: some View {
        List {
            ForEach(petManager.pets) { pet in
                    PetRowView(pet: pet)
            }
            .onDelete(perform: removeRow)
        } 
    }
}

struct PetRowView: View {
    @ObservedObject var pet: Pet
    
    @EnvironmentObject var petManager: PetManager
    
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

#Preview {
    PetsListView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

