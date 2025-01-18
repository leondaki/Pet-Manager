//
//  ContentView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            TasksListView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark")
                }
            PetsListView()
                .tabItem {
                    Label("Pets", systemImage: "folder")
                }
        }
    }
}

struct HomeView:View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(name: "TrendSansOne", size: 30)!
        ]
    }
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Hi, Leonidas!")
                        .font(Font.custom("TrendSansOne", size: 40))
                    Text("You have \(taskManager.tasks.count) upcoming tasks.")
                        .font(Font.custom("WorkSans-Regular", size: 20))
                    
                }
                .padding(.top, 24)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pet Manager")
                            .font(.custom("TrendSansOne", size: 30))
                            .padding(.bottom, -30)
                            .foregroundStyle(Color(red: 1.0, green: 0.969, blue: 0.925))
                    }
                }
                .toolbarBackground(Color(red: 0.392, green: 0.335, blue: 0.272), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                
                
                TasksList()
            }
            .background(Color(red: 1.0, green: 0.969, blue: 0.925))
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
