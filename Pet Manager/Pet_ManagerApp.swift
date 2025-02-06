//
//  Pet_ManagerApp.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI
import SwiftData

@main
struct Pet_ManagerApp: App {
    @Query var tasks: [TaskItem]
    
    @StateObject private var taskManager = TaskManager()
    @StateObject private var tabOption = TabOption()
    @StateObject private var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManager)
                .environmentObject(tabOption)
                .environmentObject(settingsManager)   
        }
        .modelContainer(for: [MyPet.self, TaskItem.self])
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
