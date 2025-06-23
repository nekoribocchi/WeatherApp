//
//  UVIndexManager.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//


import Foundation
import CoreLocation

// MARK: - UV Index Manager

/// UV指数データの取得と管理を行うメインクラス
/// - SwiftUIのObservableObjectとして動作
/// - LocationServiceと連携して現在地のUV指数を取得
/// - WeatherManagerと同様の設計パターンを採用
@MainActor
@available(iOS 16.0, *)
class UVIndexManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 現在のUV指数データ（SwiftUIでバインド可能）
    @Published var currentUVIndex: UVIndexData?
    
    /// ローディング状態（SwiftUIでバインド可能）
    @Published var isLoading = false
    
    /// エラーメッセージ（SwiftUIでバインド可能）
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    
    private let uvIndexService: UVIndexServiceProtocol
    private let locationService: LocationServiceProtocol
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameters:
    ///   - uvIndexService: UV指数サービス（テスト時にモック注入可能）
    ///   - locationService: 位置情報サービス（テスト時にモック注入可能）
    init(
        uvIndexService: UVIndexServiceProtocol? = nil,
        locationService: LocationServiceProtocol? = nil
    ) {
        // 依存性の注入（テスト時にモックを注入可能）
        self.uvIndexService = uvIndexService ?? UVIndexService()
        self.locationService = locationService ?? LocationService()
    }
    
    // MARK: - Public Methods
    
    /// 現在地のUV指数を取得
    /// - 位置情報の許可確認→位置取得→UV指数取得の順で実行
    func getCurrentUVIndex() {
        Task {
            await performUVRequest { [weak self] in
                guard let self = self else { return }
                
                // 位置情報の許可状態をチェック
                try await self.checkLocationPermission()
                
                // 現在位置を取得
                let location = try await self.locationService.getCurrentLocation()
                
                // UV指数データを取得
                let uvData = try await self.uvIndexService.getCurrentUVIndex(for: location)
                
                self.currentUVIndex = uvData
            }
        }
    }
    
    /// 指定した座標のUV指数を取得
    /// - Parameters:
    ///   - lat: 緯度
    ///   - lon: 経度
    func getCurrentUVIndex(lat: Double, lon: Double) {
        Task {
            await performUVRequest { [weak self] in
                guard let self = self else { return }
                
                let location = CLLocation(latitude: lat, longitude: lon)
                let uvData = try await self.uvIndexService.getCurrentUVIndex(for: location)
                
                self.currentUVIndex = uvData
            }
        }
    }
    
    /// エラーメッセージをクリア
    func clearError() {
        errorMessage = ""
    }
    
    // MARK: - Computed Properties
    
    /// 現在のUV指数カテゴリの色を取得
    /// - SwiftUIのビューで使用するための便利プロパティ
    var currentUVCategoryColor: String {
        guard let category = currentUVIndex?.category else {
            return "gray"
        }
        
        switch category {
        case .low:
            return "green"
        case .moderate:
            return "yellow"
        case .high:
            return "orange"
        case .veryHigh:
            return "red"
        case .extreme:
            return "purple"
        }
    }
    
    // MARK: - Private Methods
    
    /// 位置情報の許可状態をチェック
    /// - Throws: LocationError
    /// - Note: WeatherManagerと同じロジックを再利用
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
    
    /// UV指数リクエストの共通処理
    /// - Parameter request: 実行する非同期処理
    /// - Note: ローディング状態管理とエラーハンドリングを統一
    private func performUVRequest(_ request: () async throws -> Void) async {
        isLoading = true
        errorMessage = ""
        
        do {
            try await request()
        } catch let error as UVIndexError {
            errorMessage = error.localizedDescription
        } catch let error as LocationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "予期しないエラーが発生しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
