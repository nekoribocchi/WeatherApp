//
//  LocationserviceProtocol.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//


import Foundation
import CoreLocation

// MARK: - Location Service Protocol

/// 位置情報サービスのプロトコル
/// - テスト時にモックオブジェクトを注入するためのプロトコル
/// - 依存性注入を可能にし、テスタビリティを向上
protocol LocationServiceProtocol: ObservableObject {
    /// 現在の位置情報許可状態
    var authorizationStatus: CLAuthorizationStatus { get }
    
    /// 位置情報が利用可能かどうか
    var isLocationAvailable: Bool { get }
    
    /// 位置情報の許可をリクエスト
    func requestLocationPermission()
    
    /// 現在位置を取得
    /// - Returns: CLLocation
    /// - Throws: LocationError
    func getCurrentLocation() async throws -> CLLocation
}
