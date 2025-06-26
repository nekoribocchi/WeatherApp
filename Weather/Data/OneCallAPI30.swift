//
//  OneCallAPI30.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//

import Foundation
import Playgrounds

/// OpenWeatherMap One Call API 3.0のレスポンス構造体
/// 現在の天気、UVインデックス、降水確率、天気アイコンを取得
struct OneCallAPI30: Codable {
    let current: Current
    let daily: [Daily]
    
    // MARK: - Current Weather
    /// 現在の天気情報
    struct Current: Codable {
        /// UVインデックス
        let uvi: Double
        
        /// 現在の天気情報配列（複数の天気状態がある場合があります）
        let weather: [Weather]
    }
    
    // MARK: - Daily Forecast
    /// 日別予報情報
    struct Daily: Codable {
        /// 降水確率（0.0〜1.0の範囲）
        let pop: Double
        
        /// その日の天気情報配列
        let weather: [Weather]
    }
    
    // MARK: - Weather Information
    /// 天気情報の詳細
    struct Weather: Codable {
        /// 天気の主カテゴリ（Rain, Snow, Clouds等）
        let main: String
        
        /// 天気の詳細説明
        let description: String
        
        /// 天気アイコンID（例: "01d", "02n"等）
        let icon: String
    }
}

// MARK: - Convenience Methods

extension OneCallAPI30 {
    
    /// 現在の天気アイコンを取得
    /// - Returns: 現在の天気アイコンID（存在しない場合は"01d"をデフォルト）
    var currentWeatherIcon: String {
        return current.weather.first?.icon ?? "01d"
    }
    
    /// 今日の天気アイコンを取得（daily配列の最初の要素）
    /// - Returns: 今日の天気アイコンID（存在しない場合は"01d"をデフォルト）
    var todayWeatherIcon: String {
        return daily.first?.weather.first?.icon ?? "01d"
    }
    
    /// 現在の天気の主カテゴリを取得
    /// - Returns: 天気の主カテゴリ（例: "Rain", "Snow"）
    var currentWeatherMain: String {
        return current.weather.first?.main ?? "Clear"
    }
    
    /// 現在の天気の説明を取得
    /// - Returns: 天気の詳細説明
    var currentWeatherDescription: String {
        return current.weather.first?.description ?? "clear sky"
    }
    
    /// 今日の降水確率を取得（パーセンテージ）
    /// - Returns: 降水確率（0〜100%）
    var todayPrecipitationProbability: Int {
        guard let todayData = daily.first else { return 0 }
        return Int(todayData.pop * 100)
    }
    
    /// 指定した日の天気アイコンを取得
    /// - Parameter dayIndex: 日のインデックス（0: 今日, 1: 明日, ...）
    /// - Returns: 指定した日の天気アイコンID
    func weatherIcon(for dayIndex: Int) -> String {
        guard dayIndex < daily.count,
              let weather = daily[dayIndex].weather.first else {
            return "01d"
        }
        return weather.icon
    }
    
    /// 指定した日の降水確率を取得
    /// - Parameter dayIndex: 日のインデックス（0: 今日, 1: 明日, ...）
    /// - Returns: 指定した日の降水確率（パーセンテージ）
    func precipitationProbability(for dayIndex: Int) -> Int {
        guard dayIndex < daily.count else { return 0 }
        return Int(daily[dayIndex].pop * 100)
    }
}

// MARK: - Weather Icon URL Generation

extension OneCallAPI30 {
    
    /// 天気アイコンのURLを生成
    /// - Parameter iconId: アイコンID（例: "01d"）
    /// - Parameter size: アイコンサイズ（デフォルト: "@2x"）
    /// - Returns: アイコンのURL
    static func weatherIconURL(iconId: String, size: String = "@2x") -> URL? {
        let urlString = "https://openweathermap.org/img/wn/\(iconId)\(size).png"
        return URL(string: urlString)
    }
    
    /// 現在の天気アイコンのURLを取得
    /// - Parameter size: アイコンサイズ（デフォルト: "@2x"）
    /// - Returns: 現在の天気アイコンのURL
    func currentWeatherIconURL(size: String = "@2x") -> URL? {
        return Self.weatherIconURL(iconId: currentWeatherIcon, size: size)
    }
    
    /// 今日の天気アイコンのURLを取得
    /// - Parameter size: アイコンサイズ（デフォルト: "@2x"）
    /// - Returns: 今日の天気アイコンのURL
    func todayWeatherIconURL(size: String = "@2x") -> URL? {
        return Self.weatherIconURL(iconId: todayWeatherIcon, size: size)
    }
}

// MARK: - Debug Description

extension OneCallAPI30: CustomStringConvertible {
    var description: String {
        return """
        OneCallAPI30:
        - Current UV Index: \(current.uvi)
        - Current Weather: \(currentWeatherDescription) (\(currentWeatherIcon))
        - Today's Precipitation: \(todayPrecipitationProbability)%
        - Daily Forecast Count: \(daily.count) days
        """
    }
}


#Playground {
let example = OneCallAPI30(
    current: .init(
        uvi: 5.4,
        weather: [.init(main: "Clouds", description: "overcast clouds", icon: "04d")]
    ),
    daily: [
        .init(pop: 0.2, weather: [.init(main: "Rain", description: "light rain", icon: "10d")]),
        .init(pop: 0.0, weather: [.init(main: "Clear", description: "clear sky", icon: "01d")])
    ]
)
    
    _ = example.currentWeatherIcon
    _ = example.todayWeatherIcon
    _ = example.currentWeatherMain
    _ = example.currentWeatherDescription
    _ = example.todayPrecipitationProbability
    _ = example.weatherIcon(for: 1)
    _ = example.precipitationProbability(for: 0)
    _ = OneCallAPI30.weatherIconURL(iconId: "01d")
    _ = example.currentWeatherIconURL()
    _ = example.todayWeatherIconURL()
    _ = example.description
}
