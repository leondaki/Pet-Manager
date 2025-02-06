//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/24/25.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject{
    @Published var selectedAccentColor: String {
        // ensures new value is immediately saved to user defaults when changed
        didSet {
            UserDefaults.standard.set(selectedAccentColor, forKey: "selectedAccentColor")
        }
    }
    
    @Published var selectedLaunchIcon: String {
        didSet {
            UserDefaults.standard.set(selectedLaunchIcon, forKey: "selectedLaunchIcon")
        }
    }
    
    init() {
        if let storedColor = UserDefaults.standard.string(forKey: "selectedAccentColor") {
            self.selectedAccentColor = storedColor
        }
        else {
            UserDefaults.standard.set("AccentColorRed", forKey: "selectedAccentColor")
            self.selectedAccentColor = "AccentColorRed"
        }
        
        if let storedLaunchIcon = UserDefaults.standard.string(forKey: "selectedLaunchIcon") {
            self.selectedLaunchIcon = storedLaunchIcon
        }
        else {
            UserDefaults.standard.set("AccentColorRed", forKey: "selectedLaunchIcon")
            self.selectedLaunchIcon = "Cat"
        }
    }
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
    
    var iconColor: String {
        switch self {
            case .appIcon: "AccentColorBlue"
            case .appIconDog: "AccentColorRed"
            case .appIconFish: "AccentColorNavy"
            case .appIconBear: "AccentColorBrown"
            case .appIconSnake: "AccentColorGreen"
            case .appIconRabbit: "AccentColorOrange"
        }
    }
    
    var launchIcon: String {
        switch self {
        case .appIcon: "Cat"
        case .appIconDog: "Dog"
        case .appIconFish: "Fish"
        case .appIconBear: "Bear"
        case .appIconSnake: "Snake"
        case .appIconRabbit: "Rabbit"
        }
    }
}

struct SettingsView:View {
    //@EnvironmentObject var settingsManager: SettingsManager
    
    @FocusState private var isNameFocused: Bool
    @State private var currentIcon: String? = UIApplication.shared.alternateIconName
   
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("username") var username: String = ""

    @EnvironmentObject var settingsManager: SettingsManager
    
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
                        text: $username,
                        placeholder: "Enter Your Name",
                        isFocused: $isNameFocused,
                        isBgVisible: false
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
                
                Section(header: Text("App Theme").font(.system(size: 18))
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
                                    settingsManager.selectedAccentColor = icon.iconColor
                                    settingsManager.selectedLaunchIcon = icon.launchIcon
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

//#Preview {
//    SettingsView()
//        .environmentObject(TaskManager(tasks:))
//        .environmentObject(SettingsManager())
//}
