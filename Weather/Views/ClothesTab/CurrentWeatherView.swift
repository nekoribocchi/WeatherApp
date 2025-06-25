//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

/// 現在の天気情報を表示するメインビュー
/// - 天気データに基づいて背景と情報を表示
/// - WeatherBackgroundViewを使用して統一的な背景表示を実現
struct CurrentWeatherView: View {
    
    // MARK: - Properties
    
    /// 現在の天気データ
    let weather: CurrentWeatherAPI25
    /// 詳細天気データ（UV指数、降水確率など）
    let oneCall: OneCallAPI30
    
    // MARK: - Computed Properties
    
    /// APIレスポンスから天気タイプを判定
    /// - 天気判定ロジックを一箇所に集約
    private var currentWeatherType: WeatherType {
        return WeatherType.from(weatherMain: weather.weather.first?.main) // 修正: 判定ロジックをWeatherTypeに移動
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 背景ビュー（天気に応じて動的に変更）
            WeatherBackgroundView(currentWeatherType) // 修正: 条件分岐を削除し、動的に天気タイプを渡す
            
            // 天気情報表示
            weatherInfoContent
        }
    }
    
    // MARK: - Private Views
    
    /// 天気情報のコンテンツ部分
    /// - 地名、UV情報、雨情報を表示
    private var weatherInfoContent: some View {
        VStack(spacing: 15) {
            // 地名表示
            CapsuleView {
                Text(weather.name)
                    .font(.callout)
            }
            
            // 天気関連情報（UV指数、雨の必要性）
            HStack {
                NeedUVView(uv: oneCall)
                NeedUmbrellaView(rain: oneCall)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CurrentWeatherView(
        weather: .mockRainyData,
        oneCall: OneCallAPI30( // 修正: プロパティ名をoneCallに統一
            current: .init(uvi: 5),
            daily: [.init(pop: 0.8)]
        )
    )
}
