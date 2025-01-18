//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/14/25.
//

import Foundation
import SwiftUI

class PetManager: ObservableObject {
    @Published var petNames: [String] = [
        "Jupiter",
        "Polly",
        "Balto",
        "Fishy"
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
            .navigationTitle("Pets List")
        }
    }
}

struct PetsList:View {
    @EnvironmentObject var petManager: PetManager
    
    var body: some View {
        List {
            ForEach(petManager.petNames, id:\.self) {
                pet in
                HStack {
                    VStack (alignment: .leading) {
                        Text(pet)
                            .font(Font.custom("TrendSansOne", size: 16))
//                        Text(task.description)
//                            .font(Font.custom("WorkSans-Regular", size: 14))
//                            .padding([.bottom], 8)
//                        Text("🐾 \(task.pet)")
//                            .font(Font.custom("WorkSans-Regular", size: 16))
//                        Text("⏰ \(task.dueTime.formatted(.dateTime.month().day().year().hour().minute()))")
//                            .font(Font.custom("WorkSans-Regular", size: 16))
                    }
                }
            }
        }
    }
}
