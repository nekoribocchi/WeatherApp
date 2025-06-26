//
//  WeatherManager+Extension.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//

import Foundation

/// WeatherManagerの拡張
/// 更新ボタン用の状態管理と最終更新日時の管理機能を追加
extension WeatherManager {
    
    // MARK: - Last Updated Management
    
    /// 最終データ更新日時を保存するためのUserDefaultsキー
    private static let lastUpdatedKey = "WeatherLastUpdated"
    
    /// 最終更新日時（UserDefaultsから取得/保存）
    var lastUpdated: Date? {
        get {
            let timestamp = UserDefaults.standard.double(forKey: Self.lastUpdatedKey)
            return timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
        }
        set {
            if let date = newValue {
                UserDefaults.standard.set(date.timeIntervalSince1970, forKey: Self.lastUpdatedKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.lastUpdatedKey)
            }
        }
    }
    
    /// 最終更新日時を現在時刻に設定
    private func updateLastUpdatedTime() {
        lastUpdated = Date()
    }
    
    // MARK: - Data State Management
    
    /// 全てのデータが正常に取得できているかを確認
    var hasAllData: Bool {
        return currentWeather != nil &&
               forecastWeather != nil &&
               oneCallAPI30 != nil
    }
    
    /// 少なくとも一つのデータが取得できているかを確認
    var hasAnyData: Bool {
        return currentWeather != nil ||
               forecastWeather != nil ||
               oneCallAPI30 != nil
    }
    
    // MARK: - Enhanced Refresh Methods
    
    /// 状態管理付きで全ての天気データを更新
    /// 既存のrefreshAllWeatherData()を拡張し、最終更新日時を自動更新
    func refreshAllWeatherDataWithState() {
        // 既に読み込み中の場合は処理を中断
        guard !isLoading else { return }
        
        // 現在のデータ状態を記録（更新前）
        let hadDataBefore = hasAnyData
        
        // 既存の更新処理を実行
        refreshAllWeatherData()
        
        // 更新完了を監視（isLoadingがfalseになったタイミングで実行）
        observeRefreshCompletion(hadDataBefore: hadDataBefore)
    }
    
    /// 現在地ベースの全データ取得（座標指定版の補完）
    func refreshAllWeatherDataForCurrentLocation() {
        guard !isLoading else { return }
        
        let hadDataBefore = hasAnyData
        
        // 現在地ベースでデータを取得
        getCurrentWeather()
        getForecast()
        
        observeRefreshCompletion(hadDataBefore: hadDataBefore)
    }
    
    /// 座標指定で全データ取得
    /// - Parameters:
    ///   - lat: 緯度
    ///   - lon: 経度
    func refreshAllWeatherData(lat: Double, lon: Double) {
        guard !isLoading else { return }
        
        let hadDataBefore = hasAnyData
        
        // 座標指定でデータを取得
        getCurrentWeather(lat: lat, lon: lon)
        getForecast(lat: lat, lon: lon)
        
        observeRefreshCompletion(hadDataBefore: hadDataBefore)
    }
    
    // MARK: - Private Helper Methods
    
    /// 更新完了を監視し、成功時に最終更新日時を設定
    /// - Parameter hadDataBefore: 更新前にデータが存在していたか
    private func observeRefreshCompletion(hadDataBefore: Bool) {
        // isLoadingの変化を監視するため、少し遅延させてチェック
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.checkRefreshCompletion(hadDataBefore: hadDataBefore)
        }
    }
    
    /// 更新完了をチェックし、成功時の処理を実行
    /// - Parameter hadDataBefore: 更新前にデータが存在していたか
    private func checkRefreshCompletion(hadDataBefore: Bool) {
        // まだ読み込み中の場合は、さらに待機
        if isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.checkRefreshCompletion(hadDataBefore: hadDataBefore)
            }
            return
        }
        
        // 更新完了後の処理
        handleRefreshCompletion(hadDataBefore: hadDataBefore)
    }
    
    /// 更新完了後の処理
    /// - Parameter hadDataBefore: 更新前にデータが存在していたか
    private func handleRefreshCompletion(hadDataBefore: Bool) {
        // エラーが発生していない場合のみ、最終更新日時を更新
        if errorMessage.isEmpty {
            // 新しいデータが取得できた場合、または既存データがある場合
            if hasAnyData {
                updateLastUpdatedTime()
            }
        }
        
        // デバッグ用ログ（必要に応じて削除）
        #if DEBUG
        print("Weather refresh completed:")
        print("- Had data before: \(hadDataBefore)")
        print("- Has data now: \(hasAnyData)")
        print("- Has all data: \(hasAllData)")
        print("- Error: \(errorMessage.isEmpty ? "None" : errorMessage)")
        print("- Last updated: \(lastUpdated?.formatted() ?? "Never")")
        #endif
    }
    
    // MARK: - Convenience Methods
    
    /// データの取得状況を文字列で返す（デバッグ用）
    var dataStatusDescription: String {
        var status: [String] = []
        
        if currentWeather != nil { status.append("現在の天気") }
        if forecastWeather != nil { status.append("予報") }
        if oneCallAPI30 != nil { status.append("詳細データ") }
        
        if status.isEmpty {
            return "データなし"
        } else {
            return status.joined(separator: "、") + "を取得済み"
        }
    }
    
    /// 更新が必要かどうかを判定
    /// - Parameter threshold: 更新が必要と判定する経過時間（秒）デフォルト: 10分
    /// - Returns: 更新が必要な場合true
    func needsRefresh(threshold: TimeInterval = 600) -> Bool {
        guard let lastUpdated = lastUpdated else {
            return true // 未取得の場合は更新が必要
        }
        
        let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdated)
        return timeSinceLastUpdate > threshold
    }
}
