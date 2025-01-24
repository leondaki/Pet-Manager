//
//  ContentView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab: Int, CaseIterable {
        case home, pets
        var title: String {
            switch self {
                case .home: return "Home"
                case .pets: return "Tasks"
            }
        }
        
        var icon: String {
            switch self {
                case .home: return "house.fill"
                case .pets: return "pawprint"
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                switch selectedTab {
                    case .home :
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                    case .pets:
                        PetsListView()
                            .tabItem {
                                Label("Pets", systemImage: "pawprint.fill")
                            }
                }
            }
            
            Spacer()

            CustomTabBar(selectedTab: $selectedTab)
                .frame(height: 100)
               
        }
        .ignoresSafeArea(edges: .bottom)
        
        
    }
}

struct HomeView:View {
//    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .font: UIFont(name: "TrendSansOne", size: 30)!
//        ]
//    }
//
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                VStack (alignment: .leading)  {
                    Text("Hi, ")
                        .font(.system(size: 34, weight: .bold))
                    + Text("Leonidas!\n")
                        .font(.system(size: 34, weight: .bold))
                    + Text("You have ")
                        .font(.system(size: 20, weight: .light))
                    + Text("\(taskManager.tasks.count - taskManager.numTasksDone)")
                        .font(.system(size: 20, weight: .light))
                    + Text(" upcoming tasks.")
                        .font(.system(size: 20, weight: .light))
                }
                .padding(.leading, 20)
                .padding(.top, 20)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Pet Manager")
                            .font(.custom("TrendSansOne", size: 30))
                            .foregroundStyle(Color(red: 1.0, green: 0.969, blue: 0.925))
                    }
                }
                .toolbarBackground(Color(red: 0.54, green: 0.46, blue: 0.37), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                 
                TasksList()
            }
        
            //.background(Color(red: 1.0, green: 0.969, blue: 0.925))
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
