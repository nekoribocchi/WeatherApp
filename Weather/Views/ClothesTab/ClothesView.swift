//
//  ClothesView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct ClothesView: View {
@ObservedObject var weatherManager: WeatherManager
    
    // MARK: - Properties

    let weather: CurrentWeatherAPI25
    let oneCall: OneCallAPI30
    
    // MARK: - Computed Properties
    private var currentWeatherType: WeatherType {
        return WeatherType.from(weatherMain: weather.weather.first?.main)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
      //     WeatherBackgroundView(currentWeatherType)
            Color.background
                .ignoresSafeArea()
            
            weatherInfoContent
        }
    }
    
    // MARK: - Private Views
    var weatherInfoContent: some View {
        VStack(spacing: 20) {
            HStack{
                CapsuleView {
                    Text(weather.name)
                        .font(.callout)
                        .padding(.horizontal, 10)
                }
                
                UpdateButton(action: { initializeWeatherData() })
            }

            HStack(spacing: 50)  {
                NeedUVView(uv: oneCall)
                NeedUmbrellaView(rain: oneCall)
            }
            
            Image("hotday")
                .resizable()
                .frame(width: 270, height:480)
        }
    }
    
    private func initializeWeatherData() {
        weatherManager.getCurrentWeather()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            weatherManager.getForecast()
        }
    }
    
    private func weatherImage(weather: WeatherManager.get)
}


#Preview {
    ClothesView(
        weatherManager: WeatherManager(),
        weather: .
        mockData,
        oneCall: OneCallAPI30(
            current: .init(uvi: 8.5, weather: [.init(main: "Rain", description: "Clear sky", icon: "01d")]),
            daily: [.init(pop: 0.2, weather: [.init(main: "Rain", description: "light rain", icon: "10d")])]
        )
    )
}
