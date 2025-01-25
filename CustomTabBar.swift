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
            // Sliding background indicator
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(ContentView.Tab.allCases.count)

                Rectangle()
                    .fill(Color.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue) // Highlight background color
                            .frame(width: tabWidth - 60, height: 4) // Size of the highlight box
                    }   
                    .frame(width: tabWidth, height: 20)
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
                   // .padding()
                }
            }
            .padding(.top, 20)
            .frame(height: 100, alignment: .top)
        }
        //.background(Color.gray) // Tab bar background color
    }
}
