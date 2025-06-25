//
//  WeatherBackgroundView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

/// 天気に応じた背景表示を担当するビュー
/// - 背景グラデーションと天気アニメーションを組み合わせて表示
/// - 天気タイプの変更に応じてスムーズにアニメーション
struct WeatherBackgroundView: View {
    
    // MARK: - Properties
    
    /// 現在の天気タイプ（外部から設定可能）
    let weatherType: WeatherType
    
    // MARK: - Initializers
    
    /// イニシャライザ
    /// - Parameter weatherType: 表示する天気タイプ（デフォルト: sunny）
    init(_ weatherType: WeatherType = .sunny) {
        self.weatherType = weatherType
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // 背景グラデーション
            backgroundGradient
                .ignoresSafeArea()
            
            // 天気アニメーション
            weatherAnimation
        }
        .animation(.easeInOut(duration: 1.5), value: weatherType) // 修正: currentWeatherからweatherTypeに変更
    }
    
    // MARK: - Private Views
    
    /// 背景グラデーションビュー
    /// - 天気タイプに応じた色でグラデーションを作成
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: WeatherColors.backgroundColors(for: weatherType)), // 修正: 色管理を分離
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    /// 天気アニメーションビュー
    /// - 天気タイプに応じたアニメーションを表示
    @ViewBuilder
    private var weatherAnimation: some View {
        switch weatherType { // 修正: currentWeatherからweatherTypeに変更
        case .rainy:
            RealisticRainView()
                .ignoresSafeArea()
        case .sunny:
            RealisticSunnyView()
                .ignoresSafeArea()

        case .cloudy:
            RealisticCloudyView()
                .ignoresSafeArea()

        }
    }
}

// MARK: - Preview

#Preview {
    WeatherBackgroundView(.sunny)
}
