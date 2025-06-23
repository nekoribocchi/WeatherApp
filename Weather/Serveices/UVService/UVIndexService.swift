//
//  UVIndexService.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import Foundation
import CoreLocation
import WeatherKit
import Playgrounds

// MARK: - UV Index Service Protocol

/// UV指数取得サービスのプロトコル
/// - テスト時にモックオブジェクトを注入するためのプロトコル
/// - 依存性注入を可能にし、テスタビリティを向上
protocol UVIndexServiceProtocol {
    /// 現在地のUV指数を取得
    /// - Parameter location: 位置情報
    /// - Returns: UV指数の値
    /// - Throws: UVIndexError
    func getCurrentUVIndex(for location: CLLocation) async throws -> UVIndexData
}

// MARK: - UV Index Data Models

/// UV指数データを格納する構造体
struct UVIndexData {
    /// UV指数の値（0-11+）
    let value: Int
    
    /// UV指数カテゴリ
    let category: UVIndexCategory
    
    /// 測定日時
    let date: Date
    
    /// 推奨事項
    let recommendation: String
}

/// UV指数のカテゴリを定義する列挙型
enum UVIndexCategory: String, CaseIterable {
    case low = "低い"           // 0-2
    case moderate = "中程度"     // 3-5
    case high = "高い"          // 6-7
    case veryHigh = "非常に高い"  // 8-10
    case extreme = "極端"       // 11+
    
    /// UV指数の値からカテゴリを判定
    /// - Parameter value: UV指数の値
    /// - Returns: UV指数カテゴリ
    static func category(for value: Int) -> UVIndexCategory {
        switch value {
        case 0...2:
            return .low
        case 3...5:
            return .moderate
        case 6...7:
            return .high
        case 8...10:
            return .veryHigh
        default:
            return .extreme
        }
    }
    
    /// カテゴリに応じた推奨事項を取得
    var recommendation: String {
        switch self {
        case .low:
            return "日焼け対策は特に必要ありません"
        case .moderate:
            return "帽子やサングラスの着用をおすすめします"
        case .high:
            return "日焼け止め、帽子、サングラスの着用が必要です"
        case .veryHigh:
            return "SPF30以上の日焼け止め、帽子、サングラス、長袖の着用を強くおすすめします"
        case .extreme:
            return "可能な限り屋内に留まり、外出時は完全防護が必要です"
        }
    }
}

// MARK: - UV Index Errors

/// UV指数取得関連のエラーを定義する列挙型
enum UVIndexError: Error, LocalizedError {
    case weatherServiceUnavailable
    case dataNotAvailable
    case invalidLocation
    case networkError(Error)
    case unknown(Error)
    
    /// ユーザーに表示するエラーメッセージ
    var errorDescription: String? {
        switch self {
        case .weatherServiceUnavailable:
            return "WeatherKitサービスが利用できません"
        case .dataNotAvailable:
            return "UV指数データが取得できませんでした"
        case .invalidLocation:
            return "無効な位置情報です"
        case .networkError(let error):
            return "ネットワークエラー: \(error.localizedDescription)"
        case .unknown(let error):
            return "不明なエラー: \(error.localizedDescription)"
        }
    }
}

// MARK: - UV Index Service Implementation

/// AppleのWeatherKitを使用してUV指数を取得するサービスクラス
/// - iOS 16.0以上で利用可能
/// - WeatherServiceを使用してリアルタイムの天気データを取得
@available(iOS 16.0, *)
class UVIndexService: UVIndexServiceProtocol {
    
    // MARK: - Private Properties
    
    /// WeatherKitのサービスインスタンス
    private let weatherService = WeatherService.shared
    
    // MARK: - Public Methods
    
    /// 現在地のUV指数を取得
    /// - Parameter location: CLLocation（緯度・経度情報）
    /// - Returns: UVIndexData構造体
    /// - Throws: UVIndexError
    func getCurrentUVIndex(for location: CLLocation) async throws -> UVIndexData {
        do {
            // WeatherKitから現在の天気情報を取得
            let weather = try await weatherService.weather(for: location)
            
            // 現在のUV指数を取得
            let uvIndex = weather.currentWeather.uvIndex
            
            // UV指数データを作成
            let category = UVIndexCategory.category(for: uvIndex.value)
            
            return UVIndexData(
                value: uvIndex.value,
                category: category,
                date: weather.currentWeather.date,
                recommendation: category.recommendation
            )
            
        } catch {
            throw mapWeatherKitError(error)
        }
    }
    
    // MARK: - Private Methods
    
    /// WeatherKitのエラーをUVIndexErrorにマッピング
    /// - Parameter error: WeatherKitのエラー
    /// - Returns: UVIndexError
    private func mapWeatherKitError(_ error: Error) -> UVIndexError {
        // Check for network errors
        if let urlError = error as? URLError {
            return .networkError(urlError)
        }
        // Handle general WeatherError
        if error is WeatherError {
            return .weatherServiceUnavailable
        }
        return .unknown(error)
    }
}

#Playground {
    let uvIndexService = UVIndexService()
    
    let  location = CLLocation(latitude: 35.6895, longitude: 139.6917) //
    let currentUV = try! await uvIndexService.getCurrentUVIndex(for: location)
    let value = currentUV.value
    let category = currentUV.category
    let recommendation = currentUV.recommendation

}
