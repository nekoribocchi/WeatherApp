//
//  WeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/18.
//

import SwiftUI
import GlassmorphismUI

// MARK: - WeatherView
struct WeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack{
                    weatherInfoContent
                    UpdateButton(action: { initializeWeatherData() })
                }
                weatherContentView
                Spacer()
            }
        }
    }
    
    private var WeatherIcon: some View {
        if let icon = weatherManager.currentWeather?.weather.first?.icon {
            Image("\(icon)")
                .resizable()
                .frame(width: 100, height: 100)
            
        }
        else{
            Image("01d")
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
    
    // MARK: - 天気情報コンテンツ
    private var weatherInfoContent: some View {
        Group {
            if let weather = weatherManager.currentWeather{
                VStack(spacing: 15) {
                    WhiteCapsule {
                        Text(weather.name)
                            .font(.callout)
                            .padding(.horizontal, 10)
                    }
                }
            } else {
                DataUnavailableView(title: "天気情報がありません")
            }
        }
    }
    
    // MARK: - 天気情報コンテンツエリア
    private var weatherContentView: some View {
        VStack(spacing: 0){
            // 気温データ表示
            temperatureSection
            
            // 予報データ表示
            forecastSection
            
            // UV・降水確率データ表示
            uvAndPrecipitationSection
        }
    }
    
    // MARK: - 気温セクション
    private var temperatureSection: some View {
        Group {
            if let forecast = weatherManager.forecastWeather,
               let weather = weatherManager.currentWeather {
                HStack{
                    WeatherIcon
                    TemperatureView(forecast: forecast, weather: weather)
                }
                .padding(60)
            } else {
                // エラー表示を共通化
                DataUnavailableView(
                    title: "気温データがありません"
                )
            }
        }
    }
    
    // MARK: - 予報セクション
    private var forecastSection: some View {
        Group {
            if let forecast = weatherManager.forecastWeather {
                ForecastView(forecast: forecast)
            } else {
                DataUnavailableView(
                    title: "予報データがありません"
                )
            }
        }
    }
    
    // MARK: - UV・降水確率セクション
    private var uvAndPrecipitationSection: some View {
        Group {
            if let oneCallAPI30 = weatherManager.oneCallAPI30 {
                HStack{
                    UVView(uv: oneCallAPI30)
                    PopView(pop: oneCallAPI30)
                }
                .padding(.horizontal) // 横方向のパディングを追加
            } else {
                // 重複していたエラー表示を共通化し、適切なメッセージに変更
                DataUnavailableView(
                    title: "詳細データがありません"
                )
            }
        }
    }
    
    // MARK: - Private Methods
    private func initializeWeatherData() {
        print("🚀 アプリ起動時の天気データ初期化を開始")
        weatherManager.getCurrentWeather()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("📅 天気予報データを取得中...")
            self.weatherManager.getForecast()
        }
    }
    
}



// MARK: - Preview
#Preview {
    WeatherView(weatherManager: WeatherManager())
}
