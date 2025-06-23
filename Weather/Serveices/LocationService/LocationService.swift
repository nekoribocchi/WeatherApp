//
//  LocationService.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
import CoreLocation

// MARK: - Location Service

/// 位置情報の取得を担当するサービスクラス
/// - CoreLocationフレームワークを使用
/// - async/awaitとContinuationを使用してdelegateパターンを非同期化
/// - @MainActorで全てのUI更新をメインスレッドで実行
@MainActor
class LocationService: NSObject, LocationServiceProtocol {
    
    // MARK: - Published Properties
    
    /// 位置情報の許可状態（SwiftUIでバインド可能）
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// 位置情報が利用可能かどうか（SwiftUIでバインド可能）
    @Published var isLocationAvailable: Bool = false
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    // 修正: Continuationの型を明確に定義（型安全性の向上）
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Public Methods
    
    /// 位置情報の許可をリクエスト
    /// - ユーザーに位置情報の使用許可ダイアログを表示
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 現在位置を取得
    /// - Returns: CLLocation（緯度・経度情報を含む）
    /// - Throws: LocationError
    /// - Note: async/awaitとContinuationを使用してdelegate処理を非同期化
    func getCurrentLocation() async throws -> CLLocation {
        // 許可状態をチェック
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            throw LocationError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
            
            /*
             requestLocation() を呼び出すと…
             
             1. OS が測位を開始
             
             2. 測位が完了すると delegate が 1 回だけ呼ばれる
                ├─ 成功: locationManager(_:didUpdateLocations:)
                └─ 失敗: locationManager(_:didFailWithError:)
             
             3. delegate 内で locationContinuation?.resume(…)
                ├─ returning: location   ← 成功時
                └─ throwing:  error      ← 失敗時
             
             4. resume された瞬間、await で待っていた getCurrentLocation() が再開し
                呼び出し側へ結果（またはエラー）が返る
             */
        }
    }
    
    // MARK: - Private Methods
    
    /// LocationManagerの初期設定
    /// - 精度設定とdelegateの設定を行う
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
        // 修正: 初期化時に isLocationAvailable も設定
        updateLocationAvailability()
    }
    
    /// 位置情報利用可能状態を更新
    /// - 許可状態に基づいて isLocationAvailable を更新
    private func updateLocationAvailability() {
        isLocationAvailable = (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways)
    }
}

// MARK: - CLLocationManagerDelegate

/// @MainActorを付けることで、全てのdelegateメソッドがメインスレッドで実行されることを保証
/// - UI更新が含まれるため、メインスレッドでの実行が必要
extension LocationService: CLLocationManagerDelegate {
    
    /// 位置情報の取得に成功した時に呼ばれるdelegateメソッド
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - locations: 取得された位置情報の配列
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            // 位置情報が空の場合、エラーを投げる
            locationContinuation?.resume(throwing: LocationError.locationNotFound)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        // 修正: メモリリークを防ぐためにcontinuationをクリア
        locationContinuation = nil
    }
    
    /// 位置情報の取得に失敗した時に呼ばれるdelegateメソッド
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - error: エラー情報
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: LocationError.locationUpdateFailed(error))
        // 修正: メモリリークを防ぐためにcontinuationをクリア
        locationContinuation = nil
    }

    /// ユーザーが位置情報の使用許可設定を変更した時に呼ばれるdelegateメソッド
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - status: 新しい許可状態
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        // 修正: メソッド呼び出しに変更（DRY原則）
        updateLocationAvailability()
    }
}
