//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI

// MARK: - CurrentWeatherView
struct CurrentWeatherView: View {
    let weather: CurrentWeatherAPI25
    let OneCall: OneCallAPI30
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
                    NeedUVView(uv: OneCall)
                    NeedUmbrellaView(rain: OneCall)
                }
            }
        }
    }
}
