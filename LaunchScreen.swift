//
//  LaunchScreen.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 2/6/25.
//

import SwiftUI

struct LaunchScreen: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var size = 0.1
    @State private var opacity = 0.0
    
    var body: some View {
        VStack {
            Image(settingsManager.selectedLaunchIcon)
                .frame(width: 60, height: 60)
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut) {
                        opacity = 1.0
                    }
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.1)) {
                        size = 0.2  // Animate to full size
                    }
                }
            
            Text("Pet Manager")
                .font(.system(size: 36, weight: .black))
                .foregroundStyle(.white)
                .padding(.top, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(settingsManager.selectedAccentColor))
    }
}

#Preview {
    LaunchScreen()
        .environmentObject(SettingsManager())
}
