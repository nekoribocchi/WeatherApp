// MARK: - ContentView.swift での使用例
import SwiftUI

struct TestUI: View {
    @StateObject private var weatherManager = WeatherManager()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if weatherManager.isLoading {
                    ProgressView("読み込み中...")
                        .scaleEffect(1.5)
                } else if !weatherManager.errorMessage.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(weatherManager.errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        
                        Button("再試行") {
                            weatherManager.clearError()
                            weatherManager.getCurrentWeather()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        VStack(spacing: 10) {
                            Button("最新の天気を取得") {
                                weatherManager.getCurrentWeather()
                            }
                            if let weather = weatherManager.currentWeather {
                                CurrentWeatherView(weather: weather)
                            } else {
                                Text("天気データがありません")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tabItem {
                            Image(systemName: "cloud.sun")
                            Text("現在の天気")
                        }
                        .tag(0)
                        
                        VStack(spacing: 10) {
                            Button("5日間予報を取得") {
                                weatherManager.getForecast()
                            }
                            if let forecast = weatherManager.forecastWeather {
                                ForecastView(forecast: forecast)
                            } else {
                                Text("予報データがありません")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("3時間予報")
                        }
                        .tag(1)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("天気アプリ")
        }
        .onAppear {
            weatherManager.getCurrentWeather()
        }
    }
}

#Preview("Content View - Loading") {
    TestUI()
}
