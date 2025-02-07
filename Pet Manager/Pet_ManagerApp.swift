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
    @StateObject private var taskManager = TaskManager()
    @StateObject private var tabOption = TabOption()
    @StateObject private var settingsManager = SettingsManager()
    
    @State private var showSplash = true
    
    // check if user toggle system notifs on when returning to app
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(taskManager)
                    .environmentObject(tabOption)
                    .environmentObject(settingsManager)
                    .opacity(showSplash ? 0 : 1) // Initially hidden

                if showSplash {
                    LaunchScreen()
                        .environmentObject(settingsManager)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.5), value: showSplash) // Smooth transition
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showSplash = false // Triggers animation
                }
            }
        }
        .modelContainer(for: [MyPet.self, TaskItem.self])
    }
    
//    init() {
//        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//    }
}
