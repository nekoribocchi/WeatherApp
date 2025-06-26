//
//  WeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/18.
//

import SwiftUI

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
        Group {
            if let oneCallAPI30 = weatherManager.oneCallAPI30 {
                AsyncImage(url: oneCallAPI30.todayWeatherIconURL()) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .background(Color.clear)
                        
                    case .failure(_):
                        fallbackWeatherIcon
                        
                    @unknown default:
                        fallbackWeatherIcon
                    }
                }
            }
        }
    }
    
    // MARK: - フォールバック用の天気アイコン
    private var fallbackWeatherIcon: some View {
        Group {
            if let icon = weatherManager.currentWeather?.weather.first?.icon {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    defaultWeatherIcon
                }
                .frame(width: 150, height: 150)
            } else {
                defaultWeatherIcon
            }
        }
    }
    
    
    
    // MARK: - デフォルト天気アイコン
    private var defaultWeatherIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 150, height: 150)
            
            Image(systemName: "cloud.sun")
                .font(.system(size: 60))
                .foregroundColor(.blue)
        }
    }
    
    
    
    
    // MARK: - 天気情報コンテンツ
    private var weatherInfoContent: some View {
        Group {
            if let weather = weatherManager.currentWeather{
                VStack(spacing: 15) {
                    CapsuleView {
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
                .padding(.horizontal,20)
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

