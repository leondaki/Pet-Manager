//
//  ContentView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var prevTab: Tab = .home
    
    enum Tab: Int, CaseIterable {
        case home, pets, settings
        
        var title: String {
            switch self {
                case .home: return "Home"
                case .pets: return "Pets"
                case .settings: return "Settings"
            }
        }
        
        var icon: String {
            switch self {
                case .home: return "house.fill"
                case .pets: return "pawprint.fill"
                case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    switch selectedTab {
                        case .home :
                            HomeView()
                               
                        case .pets:
                            PetsListView()
                               
                        case .settings:
                            SettingsView()
                    }
                }
                .animation(.easeInOut, value: selectedTab)
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                    .frame(height: 100)
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "pawprint.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                            .foregroundColor(Color.gray)
                        
                        Text("Pet Manager")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(Color.gray)
                    }
                }
                
                if selectedTab == .home {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button {} label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundStyle(Color.black)
                                    .background(.white)
                            }
                        }
                    }
                }
            }
        }      
    }
}

struct HomeView:View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 110)
                        .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                    
                    VStack (alignment: .leading)  {
                        Text("Hello Leonidas!\n")
                            .font(.system(size: 34, weight: .bold))
                        + Text("You have ")
                            .font(.system(size: 20, weight: .regular))
                        + Text("\(taskManager.tasks.count - taskManager.numTasksDone)")
                            .font(.system(size: 20, weight: .regular))
                        + Text(" upcoming tasks.")
                            .font(.system(size: 20, weight: .regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                .padding(.bottom, 20)
                
                
                
                TasksList()

            }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
