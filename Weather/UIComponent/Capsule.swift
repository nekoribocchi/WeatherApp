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
        if #available(iOS 26.0, *) {
            content
                .padding()
                .glassEffect()
        } else {
            content
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(25)
        }
    }
}

@available(iOS 26.0, *)
#Preview("iOS 26+") {
    CapsuleView{
        Circle()
    }
}


@available(iOS 18.0, *)
#Preview("iOS 18") {
    CapsuleView{
        Text("Tokyo")
    }
}
