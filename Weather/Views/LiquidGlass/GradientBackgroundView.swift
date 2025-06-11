//  GradientBackgroundView.swift
//  Weather
//
//  Created by AI Assistant on 2025/06/11.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6), Color.cyan.opacity(0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackgroundView()
}
