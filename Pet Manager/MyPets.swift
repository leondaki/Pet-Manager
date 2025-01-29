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
                    .fill(Color.white)
                    .frame(height: 110)
                    .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                    .overlay {
                        VStack (alignment: .leading)  {
                            Text("Pets")
                                .font(.system(size: 34, weight: .bold))
                            + Text("\nYou have \(petManager.pets.count) pets.")
                                .font(.system(size: 20, weight: .regular))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    }
                PetsList()
            }
        }

    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    @State private var swipedRow: UUID? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 0) {
                ForEach(petManager.pets) { pet in
                    PetRowView(pet: pet, id: pet.id, swipedRow: $swipedRow)
                        .transition(.move(edge: .leading))
                }
            }
            .padding(.top, 30)
        }
        .onTapGesture {
            withAnimation {
                swipedRow = nil
            }
        }
        .onDisappear {
            withAnimation {
                swipedRow = nil
            }
        }
    }
}

#Preview {
    PetsListView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}

struct PetRowView: View {
    @ObservedObject var pet: Pet
    
    let id: UUID
    @Binding var swipedRow: UUID?
    
    @State private var rowOffset: CGFloat = 0
    @State private var dragTranslation: CGFloat = 0
    
    @EnvironmentObject var petManager: PetManager
    
    var body: some View {
        ZStack {

            Rectangle()
                .padding()
                .frame(height: 100)
                .foregroundColor(.white)
                .background(.white)
                .overlay {
                    NavigationLink(destination: EditPetView(pet: pet, tempName: pet.name)) {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 40)
                }
            
                .offset(x: (swipedRow == id ? rowOffset + dragTranslation : 0))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            withAnimation {
                                if swipedRow != id {
                                    swipedRow = id
                                }
                                dragTranslation = gesture.translation.width
                            }
                        }
                        .onEnded { gesture in
                            withAnimation {
                                if rowOffset + gesture.translation.width < -100 { // Snap open
                                    rowOffset = -100 // Fixed position for "open"
                                } else { // Snap closed
                                    rowOffset = 0
                                    swipedRow = nil
                                }
                                dragTranslation = 0 // Reset drag translation
                            }
                        }
                )
                .animation(.easeInOut, value: dragTranslation) // Smooth animation for drag
            
            Text(pet.name)
                .font(.system(size: 24, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 50)
                .foregroundStyle(Color.black)
    
            VStack (spacing: 0) {
                VStack (spacing: 0){
                    Button (action: {
                        petManager.deletePet(pet)
                    }) {
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 100, height: 100)
                .background(.red)
            }
            .zIndex(-1)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }

        
        Divider()
 
    }
}
