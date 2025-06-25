//
//  WeatherManager.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
import CoreLocation

// MARK: - Weather Manager

/// 天気データの取得と管理を行うメインクラス
/// - SwiftUIのObservableObjectとして動作
/// - 依存性注入によりテスト可能な設計
/// - 位置情報サービスとAPIサービスを統合
@MainActor
class WeatherManager: ObservableObject {
    static let shared = WeatherManager()
    // MARK: - Published Properties
    
    /// 取得した現在の天気データ（SwiftUIでバインド可能）
    @Published var currentWeather: WeatherData?
    
    @Published var currentUV: UVData?
    /// 取得した予報データ（SwiftUIでバインド可能）
    @Published var forecastWeather: ForecastData?
    
    /// ローディング状態（SwiftUIでバインド可能）
    @Published var isLoading = false
    
    /// エラーメッセージ（SwiftUIでバインド可能）
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    
    private let apiService: WeatherAPIServiceProtocol
    private let locationService: LocationServiceProtocol
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameters:
    ///   - apiService: 天気APIサービス（テスト時にモック注入可能）
    ///   - locationService: 位置情報サービス（テスト時にモック注入可能）
    init(
        apiService: WeatherAPIServiceProtocol? = nil,
        locationService: LocationServiceProtocol? = nil
    ) {
        let apiKey = Self.getAPIKey()
        
        // 依存性の注入（テスト時にモックを注入可能）
        self.apiService = apiService ?? WeatherAPIService(apiKey: apiKey)
        self.locationService = locationService ?? LocationService()
    }
    
    // MARK: - Public Methods
    
    /// 現在の天気を取得（現在地ベース）
    /// - 位置情報の許可確認→位置取得→天気データ取得の順で実行
    func getCurrentWeather() {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                // 修正: 位置情報許可チェックを別メソッドに分離
                try await self.checkLocationPermission()
                
                // 現在位置を取得
                let location = try await self.locationService.getCurrentLocation()
                
                // 天気データを取得
                let weatherData = try await self.apiService.fetchCurrentWeather(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
                
                let uvData = try await self.apiService.fetchUV(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
                self.currentWeather = weatherData
                self.currentUV = uvData
            }
        }
    }
    
    /// 3時間予報を取得（現在地ベース）
    /// - 位置情報の許可確認→位置取得→予報データ取得の順で実行
    func getForecast() {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                // 修正: 位置情報許可チェックを別メソッドに分離（重複コード削減）
                try await self.checkLocationPermission()
                
                // 位置情報の取得
                let location = try await self.locationService.getCurrentLocation()
                
                // 予報データを取得
                let forecastData = try await self.apiService.fetchForecast(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
                
                self.forecastWeather = forecastData
            }
        }
    }
    
    /// 指定した座標の現在の天気を取得
    /// - Parameters:
    ///   - lat: 緯度
    ///   - lon: 経度
    func getCurrentWeather(lat: Double, lon: Double) {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                let weatherData = try await self.apiService.fetchCurrentWeather(lat: lat, lon: lon)
                self.currentWeather = weatherData
            }
        }
    }
    
    /// 指定した座標の5日間予報を取得
    /// - Parameters:
    ///   - lat: 緯度
    ///   - lon: 経度
    func getForecast(lat: Double, lon: Double) {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                let forecastData = try await self.apiService.fetchForecast(lat: lat, lon: lon)
                self.forecastWeather = forecastData
            }
        }
    }
    
    /// エラーメッセージをクリア
    func clearError() {
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    
    /// APIキーを取得
    /// - Returns: OpenWeatherMap APIキー
    /// - Note: Config.plistから取得、見つからない場合はfatalError
    static func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["OpenWeatherAPIKey"] as? String,
              !key.isEmpty else {
            fatalError("API Key が設定されていません。Config.plistを作成してOpenWeatherAPIKeyを追加してください。")
        }
        return key
    }
    
    /// 位置情報の許可状態をチェック
    /// - Throws: LocationError
    /// - Note: 修正により重複コードを削減
    private func checkLocationPermission() async throws {
        switch locationService.authorizationStatus {
        case .notDetermined:
            locationService.requestLocationPermission()
            throw LocationError.permissionNotDetermined
        case .denied, .restricted:
            throw LocationError.permissionDenied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            throw LocationError.unknown
        }
    }
    
    /// 天気データリクエストの共通処理
    /// - Parameter request: 実行する非同期処理
    /// - Note: ローディング状態管理とエラーハンドリングを統一
    private func performWeatherRequest(_ request: () async throws -> Void) async {
        isLoading = true
        errorMessage = ""
        
        do {
            try await request()
        } catch let error as WeatherAPIError {
            errorMessage = error.localizedDescription
        } catch let error as LocationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "予期しないエラーが発生しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
