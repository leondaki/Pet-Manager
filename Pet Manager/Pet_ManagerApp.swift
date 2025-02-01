//
//  Pet_ManagerApp.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/12/25.
//

import SwiftUI

@main
struct Pet_ManagerApp: App {
    @StateObject private var taskManager = TaskManager()
    @StateObject private var petManager = PetManager()
    @StateObject private var tabOption = TabOption()
    @StateObject private var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManager)
                .environmentObject(petManager)
                .environmentObject(tabOption)
                .environmentObject(settingsManager)
                
        }
    }
}
