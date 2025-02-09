//
//  test.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 2/7/25.
//

import Foundation
import SwiftUI  

struct MyView: View {
    var items = ["Apple", "Banana", "Cherry", "Date"]
    var inco = "se"
    var body: some View {
            List {
                if !inco.isEmpty {
                    Section(header: Text("Upcoming Tasks")
                        .font(.system(size: 18))
                        .listRowInsets(EdgeInsets())
                        .padding(.top, 20).padding(.bottom, 10)) {
                            ForEach(items, id: \.self) { item in
                                Text(item)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            
                                        } label: {
                                            Label("Pin", systemImage: "pin")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                }
            }
    }
//    func deleteItem(_ item: String) {
//        items.removeAll { $0 == item }
//    }
//    
//    func pinItem(_ item: String) {
//        print("\(item) pinned")
//    }
}

#Preview {
    MyView()
}
