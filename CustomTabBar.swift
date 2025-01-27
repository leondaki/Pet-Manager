//
//  CustomTabBar.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 1/23/25.
//

import Foundation
import SwiftUI

struct CustomTabBar:View {
    @Binding var selectedTab: ContentView.Tab
    
    private func switchTab(newTab: ContentView.Tab) {
        if selectedTab != newTab {
            selectedTab = newTab
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.gray.opacity(0.2), radius: 1, y: -2)
            
            VStack (spacing: 0) {
                // Sliding background indicator
                GeometryReader { geometry in
                    let tabWidth = geometry.size.width / CGFloat(ContentView.Tab.allCases.count)
                    
                    Rectangle()
                        .fill(Color.clear)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue) // Highlight background color
                                .frame(width: tabWidth - 60)
                        }
                        .frame(width: tabWidth, height: 6)
                        .offset(x: tabWidth * CGFloat(selectedTab.rawValue))
                        .animation(.easeInOut(duration: 0.3), value: selectedTab) // Smooth sliding
                }
                
                // Tab items
                HStack {
                    ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            switchTab(newTab: tab)
                        }) {
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(selectedTab == tab ?
                                                     Color.blue : Color.gray)
                                
                                Text(tab.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(selectedTab == tab ?
                                                     Color.blue : Color.gray)
                            }
                            .frame(maxWidth: .infinity) // Equal spacing for all tabs
                        }
                    }
                    
                }
                .padding(.bottom, 20)
                .frame(height: 100)
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(TaskManager())
        .environmentObject(PetManager())
}


