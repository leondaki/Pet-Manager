//
//  ContentView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI

class TabOption:ObservableObject {
    @Published var tab: Tab = .home
}

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


struct ContentView: View {
    @State var selectedTab: Tab = .home

    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.shadowColor = .clear // This removes the bottom border

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
    }
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
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
                //.animation(.easeInOut, value: selectedTab)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
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
                
                if selectedTab != .settings
                {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            NavigationLink(destination: selectedTab == .home ? AnyView(AddTaskView()) : AnyView((AddPetsView()))) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundStyle(Color.accentColor)
                                    .background(.clear)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct HomeView:View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    @State private var showText = false

    var body: some View {
        let numTasks = taskManager.tasks.count
        
        VStack (spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(height: 110)
                        .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                    
                    VStack (alignment: .leading, spacing: 0)  {
                        Text("Hello \(settingsManager.username.isEmpty ? "" : settingsManager.username)")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(Color.accentColor)
                       
                        HStack (spacing: 0) {
                            Text("You have ")
                                .contentTransition(.numericText(value: Double(numTasks)))
                                .font(.system(size: 20, weight: .regular))
                            
                            Text("\(numTasks) ")
                                .contentTransition(.numericText(value: Double(numTasks)))
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(Color.accentColor)
                            
                            Text(numTasks == 1 ? "upcoming task.":"upcoming tasks.")
                                .font(.system(size: 20, weight: .regular))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                .zIndex(1)
                
                TasksList()
                   
            }
            .background(Color(UIColor.secondarySystemBackground))

    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
        .environmentObject(TabOption())
        .environmentObject(SettingsManager())
}
