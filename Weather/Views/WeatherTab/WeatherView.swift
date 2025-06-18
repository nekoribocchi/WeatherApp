//
//  WeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/18.
//

import SwiftUI
// MARK: - WeatherView（MainViewのWeatherManagerを受け取る版）
struct WeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        VStack(spacing: 20) {
            Button("更新") {
                weatherManager.getForecast()
            }
            .buttonStyle(.borderedProminent)
            
            if let forecast = weatherManager.forecastWeather {
                ForecastView(forecast: forecast)
            } else {
                Text("予報データがありません")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    let weatherManager = WeatherManager()
    WeatherView(weatherManager: weatherManager)
}
