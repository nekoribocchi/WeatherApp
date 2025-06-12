import SwiftUI
import CoreLocation

// MARK: - Main View
struct ContentView: View {
    @StateObject private var weatherManager = WeatherManager()
    
    var body: some View {
        VStack(spacing: 30) {
            if weatherManager.isLoading {
                ProgressView("読み込み中...")
                    .scaleEffect(1.2)
            } else if let weather = weatherManager.currentWeather {
                ClothesView(weather: weather)
            } else if !weatherManager.errorMessage.isEmpty {
                ErrorView(message: weatherManager.errorMessage) {
                    weatherManager.getCurrentWeather()
                }
            } else {
                GetWeatherView {
                    weatherManager.getCurrentWeather()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
