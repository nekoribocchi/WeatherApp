//
//  LocationService.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
import CoreLocation

// MARK: - Location Service
@MainActor
class LocationService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLocationAvailable: Bool = false
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Public Methods
    
    /// 位置情報の許可をリクエスト
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 現在位置を取得
    func getCurrentLocation() async throws -> CLLocation {
        // 許可状態をチェック
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            throw LocationError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
            // requestLocation() を呼び出すと…
            //
            // 1. OS が測位を開始
            //
            // 2. 測位が完了すると delegate が 1 回だけ呼ばれる
            //    ├─ 成功: locationManager(_:didUpdateLocations:)
            //    └─ 失敗: locationManager(_:didFailWithError:)
            //
            // 3. delegate 内で locationContinuation?.resume(…)
            //    ├─ returning: location   ← 成功時
            //    └─ throwing:  error      ← 失敗時
            //
            // 4. resume された瞬間、await で待っていた getCurrentLocation() が再開し
            //    呼び出し側へ結果（またはエラー）が返る


        }
    }
    
    // MARK: - Private Methods
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
}

// MARK: - CLLocationManagerDelegate
/// @MainActorを付けることで、全てのdelegateメソッドがメインスレッドで実行されることを保証
extension LocationService: @MainActor CLLocationManagerDelegate {
    
    /// 位置情報の取得に成功した時に呼ばれるdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            // 位置情報が空の場合、エラーをなげる
            locationContinuation?.resume(throwing: LocationError.locationNotFound)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    /// 位置情報の取得に失敗した時に呼ばれるdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: LocationError.locationUpdateFailed(error))
        locationContinuation = nil
    }

    /// ユーザーが位置情報の使用許可設定を変更した時に呼ばれるdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        isLocationAvailable = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
}

// MARK: - Location Errors

enum LocationError: Error, LocalizedError {
    case permissionNotDetermined
    case permissionDenied
    case locationNotFound
    case locationUpdateFailed(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionNotDetermined:
            return "位置情報の使用許可がまだ決まっていません"
        case .permissionDenied:
            return "位置情報の許可が必要です"
        case .locationNotFound:
            return "位置情報が取得できませんでした"
        case .locationUpdateFailed(let error):
            return "位置情報の更新に失敗しました: \(error.localizedDescription)"
        case .unknown:
            return "不明なえらー"
        }
    }
}
/*
 呼び出し側 ──────────> getCurrentLocation()  ────────┐
                   (async 関数)                       │ suspend
                                                     ▼
 LocationService.getCurrentLocation()
 ┌──────────────────────────────────────────────────────────┐
 │ 1. withCheckedThrowingContinuation { continuation in    │
 │ 2.     self.locationContinuation = continuation         │
 │ 3.     locationManager.requestLocation()                │
 │ } ←―★ここで関数はいったん停止（suspend）               │
 └──────────────────────────────────────────────────────────┘
                               ▲
                               │ iOS が測位完了
 CLLocationManagerDelegate ----┘
 didUpdateLocations / didFailWithError が発火
 ┌──────────────────────────────────────────────────────────┐
 │ 4. continuation?.resume(returning: location)  または     │
 │    continuation?.resume(throwing: error)                │
 │ 5. locationContinuation = nil  （二度呼び防止）         │
 └──────────────────────────────────────────────────────────┘
          ▲
          │ resume された瞬間、待っていた getCurrentLocation()
          │ が再開し、結果が戻る
 呼び出し側 <────────── 6. location を受け取って続行

 */
