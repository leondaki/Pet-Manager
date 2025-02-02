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

enum AppIcon: String, CaseIterable {
    case appIcon = "Default"
    case appIconDog = "AppIcon-Dog"
    case appIconFish = "AppIcon-Fish"
    case appIconBear = "AppIcon-Bear"
    case appIconSnake = "AppIcon-Snake"
    case appIconRabbit = "AppIcon-Rabbit"
    
    var iconValue: String? {
        if self == .appIcon {
            return nil
        } else {
            return rawValue
        }
    }
    
    var previewImage: String {
        switch self {
            case .appIcon: "AppIcon-Preview"
            case .appIconDog: "AppIcon-Dog-Preview"
            case .appIconFish: "AppIcon-Fish-Preview"
            case .appIconBear: "AppIcon-Bear-Preview"
            case .appIconSnake: "AppIcon-Snake-Preview"
            case .appIconRabbit: "AppIcon-Rabbit-Preview"
        }
    }
}

struct SettingsView:View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    @FocusState private var isNameFocused: Bool
    @State private var currentIcon: String? = UIApplication.shared.alternateIconName
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    private func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                DispatchQueue.main.async {
                    notificationsEnabled = granted
                    if !granted {
                        // Handle denied permissions gracefully
                        print("Notifications permission denied.")
                    }
                }
            }
    }
    
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
                Section(header: Text("Username")
                    .font(.system(size: 18))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 30).padding(.bottom, 10)) {
                    CustomInputField(
                        text: $settingsManager.username,
                        placeholder: "Enter Your Name",
                        isFocused: $isNameFocused
                    )
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                }
               

                Section(header: Text("Notifications")
                    .font(.system(size: 18))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 10)
                    .padding(.bottom, 10)) {
                                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                                .onChange(of: notificationsEnabled) { _, newValue in
                                    if newValue {
                                        requestNotificationPermission()
                                    } else {
                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                    }
                                }
                            }
                
                Section(header: Text("App Icon").font(.system(size: 18))
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 10)
                    .padding(.bottom, 10)) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 40)
                    {
                        ForEach(AppIcon.allCases, id:\.self) { icon in
                            HStack {
                                Image(icon.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: Color.gray.opacity(0.3), radius: 2, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(currentIcon == icon.iconValue ? Color.gray : Color.clear, lineWidth: 3)
                                            .padding(-6)
                                    )
                                
                            }
                            .onTapGesture {
                                UIApplication.shared.setAlternateIconName(icon.iconValue)
                                withAnimation {
                                    currentIcon = UIApplication.shared.alternateIconName
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
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
