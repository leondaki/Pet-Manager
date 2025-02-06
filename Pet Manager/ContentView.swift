//
//  ContentView.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI
import SwiftData

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
    @EnvironmentObject var settingsManager: SettingsManager
    
    @Query(sort: \MyPet.name) private var pets: [MyPet]
    @Query(sort: \TaskItem.dueTime) private var tasks: [TaskItem]
    @Environment(\.modelContext) var modelContext: ModelContext
    
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
                            HomeView(tasks: tasks, pets: pets)
                               
                        case .pets:
                            PetsListView(pets: pets)
                               
                        case .settings:
                            SettingsView()
                    }
                }
                //.animation(.easeInOut, value: selectedTab)
                Button("delete all") {
                    for index in 0...tasks.count-1 {
                        let task = tasks[index]
                        modelContext.delete(task)
                    }
                }
                .buttonStyle(.borderedProminent)
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

                if selectedTab != .settings {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {    
                            NavigationLink(destination: selectedTab == .home ? AnyView(AddTaskView(pets: pets, tasks: tasks, tempPet: pets[0])) : AnyView(AddPetsView(pets: pets)))
                             {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundStyle(Color(settingsManager.selectedAccentColor))
                                    .background(.clear)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
     
        .tint(Color(settingsManager.selectedAccentColor))
    }
   
}

struct HomeView:View {
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var settingsManager: SettingsManager
    
    @State private var showText = false
    
    let tasks: [TaskItem]
    let pets: [MyPet]
    
    var body: some View {
        let numTasks = tasks.count

        VStack (spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(height: 110)
                        .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                    
                    VStack (alignment: .leading, spacing: 0)  {
                        Text("Hello \(UserDefaults.standard.string(forKey: "username") ?? "")")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(Color(settingsManager.selectedAccentColor))
                       
                        HStack (spacing: 0) {
                            Text("You have ")
                                .contentTransition(.numericText(value: Double(numTasks)))
                                .font(.system(size: 20, weight: .regular))
                            
                            Text("\(numTasks) ")
                                .contentTransition(.numericText(value: Double(numTasks)))
                                .font(.system(size: 20, weight: .regular))
                                .foregroundStyle(Color(settingsManager.selectedAccentColor))
                            
                            Text(numTasks == 1 ? "upcoming task.":"upcoming tasks.")
                                .font(.system(size: 20, weight: .regular))
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                .zIndex(1)
            
           
            
            TasksList(tasks: tasks, pets: pets)
                   
            }
            .background(Color(UIColor.secondarySystemBackground))

    }
}
 
#Preview {
     let preview = PreviewContainer([MyPet.self, TaskItem.self])
     return ContentView()
        .environmentObject(TaskManager())
        .environmentObject(TabOption()) 
        .environmentObject(SettingsManager())
        .modelContainer(preview.container)
}
