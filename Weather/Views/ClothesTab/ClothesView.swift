//
//  ClothesView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

/// 現在の天気情報を表示するメインビュー
/// - 天気データに基づいて背景と情報を表示
/// - WeatherBackgroundViewを使用して統一的な背景表示を実現
struct ClothesView: View {
    
    // MARK: - Properties
    
    /// 現在の天気データ
    let weather: CurrentWeatherAPI25
    /// 詳細天気データ（UV指数、降水確率など）
    let oneCall: OneCallAPI30
    
    // MARK: - Computed Properties
    private var currentWeatherType: WeatherType {
        return WeatherType.from(weatherMain: weather.weather.first?.main)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 背景ビュー（天気に応じて動的に変更）
           //WeatherBackgroundView(currentWeatherType)
            Color.background
                .ignoresSafeArea()
            // 天気情報表示
            weatherInfoContent
        }
    }
    
    // MARK: - Private Views
    
    /// 天気情報のコンテンツ部分
    /// - 地名、UV情報、雨情報を表示
    var weatherInfoContent: some View {
        VStack(spacing: 10) {
            // 地名表示
            CapsuleView {
                Text(weather.name)
                    .font(.callout)
                    .padding(.horizontal, 10)
            }
            
            // 天気関連情報（UV指数、雨の必要性）
            HStack(spacing: 50)  {
                NeedUVView(uv: oneCall)
                NeedUmbrellaView(rain: oneCall)
            }
            
            Image("g")
                .resizable()
                .frame(width: 270, height:480)
            
            
        }
    }
}


#Preview {
    ClothesView(
        weather: .mockData,
        oneCall: OneCallAPI30(
            current: .init(uvi: 8.5, weather: [.init(main: "Clear", description: "Clear sky", icon: "01d")]),
            daily: [.init(pop: 0.2, weather: [.init(main: "Rain", description: "light rain", icon: "10d")])]
        )
    )
}
