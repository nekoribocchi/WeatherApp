//
//  ForecastView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//
//
//  ForecastView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI

// MARK: - ForecastView
struct ForecastView: View {
    let forecast: ForecastAPI25
    
    var body: some View {
        CapsuleView {
            VStack(spacing: 15) {
                // 時間ごとの予報
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(forecast.list.prefix(9), id: \.dt) { item in
                            ForecastItemView(item: item)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                

            }
            .padding(.vertical, 10)
        }
        .padding()
    }

}

#Preview("Forecast View") {
    ForecastView(forecast: ForecastAPI25.mockData)
        .padding()
}
