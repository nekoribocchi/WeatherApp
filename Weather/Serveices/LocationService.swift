//
//  LocationService.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
import CoreLocation

// MARK: - Location Service Protocol

protocol LocationServiceProtocol: ObservableObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    var isLocationAvailable: Bool { get }
    
    func requestLocationPermission()
    func getCurrentLocation() async throws -> CLLocation
}

// MARK: - Location Service
@MainActor
class LocationService: NSObject, LocationServiceProtocol, ObservableObject {
    
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

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: LocationError.locationNotFound)
            locationContinuation = nil
            return
        }
        
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: LocationError.locationUpdateFailed(error))
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        isLocationAvailable = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
}

// MARK: - Location Errors

enum LocationError: Error, LocalizedError {
    case permissionDenied
    case locationNotFound
    case locationUpdateFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "位置情報の許可が必要です"
        case .locationNotFound:
            return "位置情報が取得できませんでした"
        case .locationUpdateFailed(let error):
            return "位置情報の更新に失敗しました: \(error.localizedDescription)"
        }
    }
}
