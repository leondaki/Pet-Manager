//
//  SwiftDataViewer.swift
//  Pet Manager
//
//  Created by Leonidas Kalpaxis on 2/5/25.
//

import Foundation
import SwiftData
import SwiftUI

struct SwiftDataViewer<Content: View>: View {
    
    private let content: Content
    private let preview: PreviewContainer
    private let items: [any PersistentModel]?
    
    init(
        preview: PreviewContainer,
        items: [any PersistentModel]? = nil,
        @ViewBuilder _ content: () -> Content
    ) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    var body:some View {
        content
            .modelContainer(preview.container)
            .onAppear(perform: {
                if let items {
                    preview.add(items: items)
                }
            })
    }
}
