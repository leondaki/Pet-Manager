//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/14/25.
//

import Foundation
import SwiftUI

struct Pet: Identifiable, Hashable {
    let id = UUID()
    var name: String
    
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
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 30) {
                ForEach(petManager.pets, id: \.id) { pet in
                    Rectangle()
                        .padding()
                        .frame(height: 40)
                        .foregroundColor(.white)
                        .overlay {
                            NavigationLink(destination: EditPetView(pet: pet, tempName: pet.name)) {
                                HStack {
                                    Text(pet.name)
                                        .font(.system(size: 24, weight: .semibold))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 50)
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer()
                               
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                        .foregroundColor(.black)
                                        .padding(.trailing,50)
                                    
                                }

                            }
                        }
                    
                    Divider()
                }
                
            }
            .padding(.top, 30)
            }
    }
}

#Preview {
    PetsListView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
