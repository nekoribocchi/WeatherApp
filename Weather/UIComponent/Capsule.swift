//
//  Capsule.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

struct CapsuleView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
            content
                .padding()
                .background(Color.white.opacity(0.93))
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
        }
    }

#Preview("iOS 18") {
    CapsuleView{
        Text("Tokyo")
    }
}
