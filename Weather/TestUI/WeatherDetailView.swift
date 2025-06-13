//
//  WeatherDetailView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI

// MARK: - WeatherDetailView
struct WeatherDetailView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

#Preview("Weather Detail - Temperature") {
    WeatherDetailView(title: "体感温度", value: "27°")
        .padding()
}

#Preview("Weather Detail - Humidity") {
    WeatherDetailView(title: "湿度", value: "65%")
        .padding()
}

#Preview("Weather Detail - Multiple") {
    HStack(spacing: 30) {
        WeatherDetailView(title: "体感温度", value: "27°")
        WeatherDetailView(title: "湿度", value: "65%")
        WeatherDetailView(title: "気圧", value: "1013 hPa")
    }
    .padding()
}
