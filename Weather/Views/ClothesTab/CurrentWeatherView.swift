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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
          
                CapsuleView {
                    Text(weather.name)
                        .font(.callout)
                }
                HStack {
                    /*
                    CapsuleView {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 30, height: 30)
                    }
                     */
                    CapsuleView{
                        Image(systemName: "cloud")
                            .font(.system(size: 23))
                    }
                    CapsuleView {
                        Text("\(Int(weather.main.temp))℃")
                            .font(.callout)
                        
                    }
                  
    
                }
            }
        }
    }
}
