//
//  WeatherColors.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

/// 天気に応じた色の定義を管理する構造体
/// - 各天気タイプに対応する背景色を提供
/// - 色の定義を一箇所に集約し、保守性を向上
struct WeatherColors {
    
    /// 天気タイプに応じた背景グラデーション用の色配列を取得
    /// - Parameter weatherType: 天気の種類
    /// - Returns: グラデーション用の色配列
    static func backgroundColors(for weatherType: WeatherType) -> [Color] {
        switch weatherType {
        case .sunny:
            return [
                Color(red: 0.25, green: 0.5, blue: 0.95),   // 深い青
                Color(red: 0.4, green: 0.7, blue: 1.0),     // 明るい青
                Color(red: 0.8, green: 0.95, blue: 1.0),    // 薄い青
                Color(red: 1.0, green: 1.0, blue: 0.95)     // 淡い黄色
            ]
        case .rainy, .cloudy: // 統合: 雨天と曇天で同じ色を使用
            return [
                Color(red: 0.6, green: 0.7, blue: 0.8),     // グレイッシュブルー
                Color(red: 0.75, green: 0.8, blue: 0.85),   // ライトグレー
                Color(red: 0.9, green: 0.92, blue: 0.95)    // 非常に薄いグレー
            ]
        }
    }
    
    /// 天気タイプに応じたプライマリカラーを取得（将来的な拡張用）
    /// - Parameter weatherType: 天気の種類
    /// - Returns: プライマリカラー
    static func primaryColor(for weatherType: WeatherType) -> Color {
        switch weatherType {
        case .sunny:
            return .yellow
        case .rainy:
            return .blue
        case .cloudy:
            return .gray
        }
    }
}
