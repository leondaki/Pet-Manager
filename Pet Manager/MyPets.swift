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
    var birthdate: Date
//    var color: Color
}

class PetManager: ObservableObject {
    @Published var pets: [Pet] = [
        Pet(name: "Buddy", birthdate: testDate(year: 2020, month: 6, day: 15)),
        Pet(name: "Mittens", birthdate: testDate(year: 2018, month: 11, day: 3)),
        Pet(name: "Charlie", birthdate: testDate(year: 2021, month: 2, day: 28))
    ]
}

struct PetsListView:View {
    var body: some View {
        @EnvironmentObject var petManager: PetManager
        
        NavigationView {
            VStack {
                PetsList()
                
                NavigationLink(destination: AddTaskView()) {
                        Text("Add Pet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
            }
            .navigationTitle("Pets List 🐾")
        }
    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    
    var body: some View {
        List {
            ForEach(petManager.pets) {
                pet in
                HStack {
                    VStack (alignment: .leading) {
                        Text(pet.name)
                            .font(Font.custom("TrendSansOne", size: 16))
                        Text("⏰ \(pet.birthdate.formatted(.dateTime.month().day().year().hour().minute()))")
                            .font(Font.custom("TrendSansOne", size: 16))
                    }
                }
            }
        }
    }
}
