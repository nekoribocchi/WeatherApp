//
//  LocationError.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import Foundation

// MARK: - Location Errors

/// 位置情報取得関連のエラーを定義する列挙型
/// - LocalizedErrorプロトコルに準拠することで、ユーザーフレンドリーなエラーメッセージを提供
/// - 位置情報の各種エラーパターンに対応
enum LocationError: Error, LocalizedError {
    case permissionNotDetermined
    case permissionDenied
    case locationNotFound
    case locationUpdateFailed(Error)
    case unknown
    
    /// ユーザーに表示するエラーメッセージ
    /// - Returns: 日本語のエラーメッセージ
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
            return "不明なエラー"
        }
    }
}
