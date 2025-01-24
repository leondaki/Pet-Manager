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
    
    var body: some View {
        ZStack {
            // Sliding background indicator
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(ContentView.Tab.allCases.count)

                Rectangle()
                    .fill(Color(red: 0.54, green: 0.46, blue: 0.37)) // Highlight background color
                    .frame(width: tabWidth, height: 100) // Size of the highlight box
                    .offset(x: tabWidth * CGFloat(selectedTab.rawValue))
                    .animation(.easeInOut(duration: 0.3), value: selectedTab) // Smooth sliding
            }

            // Tab items
            HStack {
                ForEach(ContentView.Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(selectedTab == tab ?
                                                 Color(red: 1, green: 0.93, blue: 0.82) : Color(red: 0.54, green: 0.46, blue: 0.37))
                        }
                        .frame(maxWidth: .infinity) // Equal spacing for all tabs
                    }
                   // .padding()
                }
            }
        }
        .background( Color(red: 1.0, green: 0.969, blue: 0.925)) // Tab bar background color
    }
}
