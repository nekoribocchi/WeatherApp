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
                weatherManager.getCurrentWeather()
                weatherManager.getForecast()
            }
            .buttonStyle(.borderedProminent)
            VStack(spacing: 20) {
                // 気温データの表示
                if let forecast = weatherManager.forecastWeather,
                   let weather = weatherManager.currentWeather,
                  let _ = weatherManager.oneCallAPI30 {
                    VStack{
                        TemperatureView(forecast: forecast, weather: weather)
                        UVView(uv: weatherManager.oneCallAPI30!)
                        PopView(pop: weatherManager.oneCallAPI30!)
                    }
                } else {
                    VStack {
                        Image(systemName: "thermometer.medium")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("気温データがありません")
                            .foregroundColor(.secondary)
                        
                        // どちらのデータが不足しているかを表示
                        if weatherManager.forecastWeather == nil && weatherManager.currentWeather == nil {
                            Text("予報と現在の天気データが必要です")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if weatherManager.forecastWeather == nil {
                            Text("予報データが不足しています")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if weatherManager.currentWeather == nil {
                            Text("現在の天気データが不足しています")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                
                // 予報データの表示
                if let forecast = weatherManager.forecastWeather {
                    ForecastView(forecast: forecast)
                } else {
                    VStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("予報データがありません")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
