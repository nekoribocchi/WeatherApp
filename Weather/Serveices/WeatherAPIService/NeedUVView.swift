//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct NeedUVView: View {
    let uvIndex: Double
    
    var body: some View {
        if uvIndex > 3 {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
                VStack(spacing: 4) {
                    Image(systemName: "sunglasses.fill")                 .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                    
                }
            }
            .accessibilityLabel("High UV index. Sunscreen recommended.")
        } else {
            EmptyView()
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        Text("Example for UV index 2.1 (should NOT show)")
        NeedUVView(uvIndex: 2.1)
        Text("Example for UV index 5.8 (should show)")
        NeedUVView(uvIndex: 5.8)
    }
    .padding()
}
