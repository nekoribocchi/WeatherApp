//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI


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
