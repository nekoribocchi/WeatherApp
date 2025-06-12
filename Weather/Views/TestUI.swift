
// MARK: - ContentView.swift での使用例
import SwiftUI

struct TestUI: View {
    @StateObject private var weatherManager = WeatherManager()
    
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
                    // 現在の天気表示
                    if let weather = weatherManager.currentWeather {
                        CurrentWeatherView(weather: weather)
                    }
                    
                    // 予報データ表示
                    if let forecast = weatherManager.forecastWeather {
                        ForecastView(forecast: forecast)
                    }
                    
                    // ボタン群
                    HStack(spacing: 20) {
                        Button("現在の天気") {
                            weatherManager.getCurrentWeather()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("5日間予報") {
                            weatherManager.getForecast()
                        }
                        .buttonStyle(.bordered)
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

#Preview("Content View - With Weather Data") {
    let manager = WeatherManager()
    // プレビュー用のモックデータ設定
    manager.currentWeather = WeatherData.mockData
    manager.forecastWeather = ForecastData.mockData
    
    return TestUI()
        .environmentObject(manager)
}

// MARK: - CurrentWeatherView
struct CurrentWeatherView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 15) {
            Text(weather.name)
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading) {
                    Text("\(Int(weather.main.temp))°")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(weather.weather.first?.description ?? "")
                        .font(.headline)
                        .textCase(.none)
                }
            }
            
            HStack(spacing: 30) {
                WeatherDetailView(title: "体感温度", value: "\(Int(weather.main.feels_like))°")
                WeatherDetailView(title: "湿度", value: "\(weather.main.humidity)%")
                WeatherDetailView(title: "気圧", value: "\(weather.main.pressure) hPa")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview("Current Weather - Sunny") {
    CurrentWeatherView(weather: WeatherData.mockData)
        .padding()
}

#Preview("Current Weather - Rainy") {
    CurrentWeatherView(weather: WeatherData.mockRainyData)
        .padding()
}

// MARK: - ForecastView
struct ForecastView: View {
    let forecast: ForecastData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("5日間の予報")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecast.list.prefix(5), id: \.dt) { item in
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

#Preview("Forecast View - Empty") {
    ForecastView(forecast: ForecastData.mockEmptyData)
        .padding()
}

// MARK: - ForecastItemView
struct ForecastItemView: View {
    let item: ForecastData.ForecastItem
    
    private var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(formattedDate)
                .font(.caption)
                .fontWeight(.medium)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(item.weather.first?.icon ?? "01d").png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .scaleEffect(0.5)
            }
            .frame(width: 40, height: 40)
            
            Text("\(Int(item.main.temp))°")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview("Forecast Item - Sunny") {
    ForecastItemView(item: ForecastData.ForecastItem.mockSunnyItem)
        .padding()
}

#Preview("Forecast Item - Cloudy") {
    ForecastItemView(item: ForecastData.ForecastItem.mockCloudyItem)
        .padding()
}

#Preview("Forecast Items - Multiple") {
    HStack {
        ForecastItemView(item: ForecastData.ForecastItem.mockSunnyItem)
        ForecastItemView(item: ForecastData.ForecastItem.mockCloudyItem)
        ForecastItemView(item: ForecastData.ForecastItem.mockRainyItem)
    }
    .padding()
}

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
