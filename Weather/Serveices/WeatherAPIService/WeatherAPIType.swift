//
//  WeatherAPIType.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import Foundation
// MARK: - Weather API Types

/// 天気APIのエンドポイントタイプを定義する列挙型
/// - 各APIエンドポイントに対応するケースを持つ
/// - URLの生成ロジックを一元化することで保守性を向上
enum WeatherAPIType {
    case current(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    
    /// APIキーを使用してリクエストURLを生成
    /// - Parameter apiKey: OpenWeatherMap APIキー
    /// - Returns: 完全なリクエストURL文字列
    func url(apiKey: String) -> String {
        let baseURL = "https://api.openweathermap.org/data/2.5"
        // 修正: 共通パラメータを定数として抽出（冗長性の削減）
        let commonParams = "&appid=\(apiKey)&units=metric&lang=ja"
        
        switch self {
        case .current(let lat, let lon):
            return "\(baseURL)/weather?lat=\(lat)&lon=\(lon)\(commonParams)"
        case .forecast(let lat, let lon):
            return "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)\(commonParams)"
        }
    }
}
