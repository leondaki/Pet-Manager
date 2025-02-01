//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/24/25.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject{
    @Published var username: String = ""
}

struct SettingsView:View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    @FocusState private var isNameFocused: Bool
    
//    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
//    
//    private func requestNotificationPermission() {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                DispatchQueue.main.async {
//                    notificationsEnabled = granted
//                    if !granted {
//                        // Handle denied permissions gracefully
//                        print("Notifications permission denied.")
//                    }
//                }
//            }
//    }
    
    var body: some View {
        
        VStack (spacing: 0) {
            Rectangle()
                .fill(Color(UIColor.systemBackground))
                .frame(height: 110)
                .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
                .zIndex(1)
                .overlay {
                    VStack (alignment: .leading)  {
                        Text("Settings")
                            .font(.system(size: 34, weight: .bold))
                        + Text("\n")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    
                }
            
            Form {
                HStack {
                    Text("Username")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.trailing, 10)
                    
                    CustomInputField(
                        text: $settingsManager.username,
                        placeholder: "Enter Your Name",
                        isFocused: $isNameFocused
                    )
                }
                
//                Section(header: Text("Notifications")) {
//                                Toggle("Enable Notifications", isOn: $notificationsEnabled)
//                                .onChange(of: notificationsEnabled) { _, newValue in
//                                    if newValue {
//                                        requestNotificationPermission()
//                                    } else {
//                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//                                    }
//                                }
//                            }
            }
            
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
        .environmentObject(SettingsManager())
}
