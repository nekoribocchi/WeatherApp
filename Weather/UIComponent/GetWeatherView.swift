//
//  Untitled.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/07.
//
import SwiftUI

// MARK: - Start View
struct GetWeatherView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: action) {
                Text("天気を取得")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    GetWeatherView(action: {})
}
