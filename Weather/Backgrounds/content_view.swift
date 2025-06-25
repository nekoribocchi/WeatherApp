//
//  ContentView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WeatherBackgroundView()
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}