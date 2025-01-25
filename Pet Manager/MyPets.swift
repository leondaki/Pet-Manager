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

struct Pet: Identifiable {
    let id = UUID()
    var name: String
}

class PetManager: ObservableObject {
    @Published var pets: [Pet] = [
        Pet(name: "Jupiter"),
        Pet(name: "Buddy"),
        Pet(name: "Mittens")
    ]
}

struct PetsListView:View {
    var body: some View {
        @EnvironmentObject var petManager: PetManager
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 110)
                .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                .overlay {
                    VStack (alignment: .leading)  {
                        Text("Pets")
                            .font(.system(size: 34, weight: .bold))
                        + Text("\nTap on a pet to edit it.")
                            .font(.system(size: 20, weight: .regular))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    
                }
                .padding(.bottom, 20)
            
            PetsList()
        }

    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    
    var body: some View {
        VStack {
            List {
                ForEach($petManager.pets) {
                    $pet in
                    
                    TextField("Pet Name", text: $pet.name)
                        .font(.system(size: 20, weight: .regular))
                        .padding()
            }
               
            .onDelete { indexSet in
                petManager.pets.remove(atOffsets: indexSet)
            }
           
                .listRowInsets(EdgeInsets())
            }
            
        }
            .listRowSpacing(10)
            
            
        }
    }

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
