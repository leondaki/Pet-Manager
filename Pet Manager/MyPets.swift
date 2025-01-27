//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/14/25.
//

import Foundation
import SwiftUI

func testDate(year: Int, month: Int, day: Int) -> Date {
    let calendar = Calendar.current
    let components = DateComponents(year: year, month: month, day: day)
    return calendar.date(from: components) ?? Date() // Default to current date if invalid
}

class Pet: Identifiable, ObservableObject, Equatable {
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    @Published var name: String
    
    init (name: String) {
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

struct PetsListView:View {
    var body: some View {
        @EnvironmentObject var petManager: PetManager
        VStack (spacing: 0) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 110)
                .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                .overlay {
                    VStack (alignment: .leading)  {
                        Text("Pets")
                            .font(.system(size: 34, weight: .bold))
                        + Text("\nTap on a pet to edit.")
                            .font(.system(size: 20, weight: .regular))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
            PetsList()
        }

    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    
    var body: some View {
        ScrollView {
            LazyVStack (alignment: .leading, spacing: 30) {
                ForEach(petManager.pets) { pet in
                    Rectangle()
                       .frame(height: 80)
                       .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 2, y: 4)
                       .foregroundColor(.white)
                       .overlay {
                           Text(pet.name)
                               .font(.system(size: 20, weight: .semibold))
                               .frame(maxWidth: .infinity, alignment: .leading)
                               .padding(.leading, 50)
                       }
                }
                
                .onDelete { indexSet in
                    petManager.pets.remove(atOffsets: indexSet)
                }
                
                .listRowInsets(EdgeInsets())
            }
            .padding(.top, 30)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    PetsListView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
