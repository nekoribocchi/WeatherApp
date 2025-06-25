//
//  WeatherBackgroundView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct WeatherBackgroundView: View {
    @State private var currentWeather: WeatherType = .sunny
    
    var body: some View {
        ZStack {
            // 背景色
            backgroundGradient
                .ignoresSafeArea()
            
            // 天気アニメーション
            weatherAnimation
            
            // コントロールパネル
            VStack {
                Spacer()
                WeatherControlPanel(currentWeather: $currentWeather)
            }
        }
        .animation(.easeInOut(duration: 1.5), value: currentWeather)
    }
    
    // 背景グラデーション
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var backgroundColors: [Color] {
        switch currentWeather {
        case .rainy:
            return [
                Color(red: 0.6, green: 0.7, blue: 0.8),
                Color(red: 0.75, green: 0.8, blue: 0.85),
                Color(red: 0.9, green: 0.92, blue: 0.95)
            ]
        case .sunny:
            return [
                Color(red: 0.25, green: 0.5, blue: 0.95),
                Color(red: 0.4, green: 0.7, blue: 1.0),
                Color(red: 0.8, green: 0.95, blue: 1.0),
                Color(red: 1.0, green: 1.0, blue: 0.95)
            ]
        case .cloudy:
            return [
                Color(red: 0.6, green: 0.7, blue: 0.8),
                Color(red: 0.75, green: 0.8, blue: 0.85),
                Color(red: 0.9, green: 0.92, blue: 0.95)
            ]
        }
    }
    
    // 天気アニメーション
    @ViewBuilder
    private var weatherAnimation: some View {
        switch currentWeather {
        case .rainy:
            RealisticRainView()
        case .sunny:
            RealisticSunnyView()
        case .cloudy:
            RealisticCloudyView()
        }
    }
}
