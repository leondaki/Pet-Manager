//
//  MyPets.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/24/25.
//

import Foundation
import SwiftUI

struct SettingsView:View {
    var body: some View {
        
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 110)
                .shadow(color: Color.gray.opacity(0.2), radius: 1, y: 3)
            
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
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}
