//
//  ForecastView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI


// MARK: - ForecastView
struct ForecastView: View {
    let forecast: ForecastData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("3時間ごとの予報")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecast.list.prefix(9), id: \.dt) { item in
                        ForecastItemView(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview("Forecast View") {
    ForecastView(forecast: ForecastData.mockData)
        .padding()
}
