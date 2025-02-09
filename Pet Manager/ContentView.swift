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
    
    @Query(sort: \MyPet.name, animation: .default) private var pets: [MyPet]
    @Query(sort: \TaskItem.dueTime, animation: .default) private var tasks: [TaskItem]
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
                            SettingsView(tasks: tasks)
                    }

                }

                CustomTabBar(selectedTab: $selectedTab)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        Text("Pet Manager")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(Color.gray)
                
                }

                if selectedTab == .home && pets.count > 0 {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            NavigationLink(destination: AddTaskView(pets: pets, tasks: tasks, tempPet: pets[0]))
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
                
                
                if selectedTab == .pets {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {    
                            NavigationLink(destination: AnyView(AddPetsView(pets: pets)))
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
    
   // @State var numUpcoming: Int = 0
   
    var body: some View {
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
                            .padding(.bottom, 6)
                       
                        HStack (spacing: 0) {
                            Image(systemName: "note.text")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .padding(.trailing, 8)
 
                            Text("You have ")
                                .font(.system(size: 20, weight: .regular))
                            
                            let numUpcoming = tasks.filter{ !$0.completed }.count
                            Text("\(numUpcoming)")
                                .contentTransition(.numericText(value: Double(numUpcoming)))
                                .animation(.easeInOut, value: tasks)
                                .font(.system(size: 20, weight: .regular))
                            
                            Text(numUpcoming == 1 ? " upcoming task":" upcoming tasks")
                                .font(.system(size: 20, weight: .regular))
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                .zIndex(1)
            
           
            if pets.count > 0 {
                TasksList(tasks: tasks, pets: pets)
            }
            else {
                Spacer()
                VStack {
                    Text("Add a pet to create tasks!")
                        .font(.system(size: 20, weight: .regular))
                        .padding()
                    
                    NavigationLink(destination: AnyView(AddPetsView(pets: pets)))
                    {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundStyle(Color(settingsManager.selectedAccentColor))
                            .background(Circle().fill(.white))
                    }
                   
                }
             
                Spacer()
            }
        
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
