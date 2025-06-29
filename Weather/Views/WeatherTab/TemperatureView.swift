//
//  TempratureView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/18.
//

import SwiftUI

struct TemperatureView: View {
    let forecast: ForecastAPI25
    let weather: CurrentWeatherAPI25
    
    var body: some View {
        VStack{
            
            Text("\(Int(weather.main.temp))℃")
                .font(.largeTitle)
                .bold()
            // 最低・最高気温
            HStack {
                Spacer()
                
                Text("\(Int(minTemp))°C")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                    .padding(5)
                
                Text("\(Int(maxTemp))°C")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                
                Spacer()
            }
        }
    }
    
    // 最低気温を計算
    private var minTemp: Double {
        forecast.list.prefix(7).map { $0.main.temp }.min() ?? 0
    }
    
    // 最高気温を計算
    private var maxTemp: Double {
        forecast.list.prefix(7).map { $0.main.temp }.max() ?? 0
    }
}


#Preview("TempratureView") {
    TemperatureView(forecast: ForecastAPI25.mockData, weather: CurrentWeatherAPI25.mockData)
    
}
