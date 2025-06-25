//
//  WeatherType.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

/// 天気の種類を定義する列挙型
/// - 天気の状態を統一的に管理し、型安全性を確保
enum WeatherType: String, CaseIterable {
    case sunny = "sunny"
    case rainy = "rainy"
    case cloudy = "cloudy"
    
    /// OpenWeatherMapのAPIレスポンスから天気タイプを判定
    /// - Parameter weatherMain: APIから取得した天気の主要カテゴリ
    /// - Returns: 対応するWeatherType、不明な場合はcloudy
    static func from(weatherMain: String?) -> WeatherType {
        guard let main = weatherMain?.lowercased() else {
            return .cloudy // デフォルト値として曇りを返す
        }
        
        switch main {
        case "rain", "drizzle", "thunderstorm":
            return .rainy
        case "clear", "sunny":
            return .sunny
        case "clouds", "mist", "fog", "haze":
            return .cloudy
        default:
            return .cloudy // 未知の天気タイプは曇りとして扱う
        }
    }
}
