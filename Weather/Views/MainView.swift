// MARK: - ContentView.swift での使用例
import SwiftUI

struct MainView: View {
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
                            refreshCurrentTabData()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        // clothesタブ
                        ZStack {
                            if let weather = weatherManager.currentWeather,
                               let uv = weatherManager.oneCallAPI30 {
                                CurrentWeatherView(weather: weather, oneCall: uv)
                            } else {
                                Text("天気データがありません")
                                    .foregroundColor(.secondary)
                            }

                            VStack {
                                Button("最新の天気を取得") {
                                    weatherManager.getCurrentWeather()
                                }
                                Spacer()
                            }
                        }
                        .tabItem {
                            Image(systemName: "cloud.sun")
                            Text("Clothes")
                        }
                        .tag(0)

                        // Weatherタブ - WeatherViewを使用
                        if let weather = weatherManager.currentWeather {
                            WeatherView(weatherManager: weatherManager)
                                .tabItem {
                                    Image(systemName: "sun.min.fill")
                                    Text("Weather")
                                }
                                .tag(1)
                        } else {
                            Text("天気データがありません")
                                .foregroundColor(.secondary)
                                .tabItem {
                                    Image(systemName: "sun.min.fill")
                                    Text("Weather")
                                }
                                .tag(1)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func refreshTabData(for tab: Int) {
        print("🔄 refreshTabData called for tab: \(tab)")
        switch tab {
        case 0:
            print("🌤️ 現在の天気を取得中...")
            weatherManager.getCurrentWeather()
        case 1:
            print("📅 予報を取得中...")
            weatherManager.getForecast()
            weatherManager.getCurrentWeather()
        default:
            break
        }
    }

    private func refreshCurrentTabData() {
        print("🔄 refreshCurrentTabData called")
        refreshTabData(for: selectedTab)
    }
}

#Preview {
    NavigationView {
        MainView()
    }
}
