//
//  WeatherAPIError.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import Foundation
// MARK: - Weather API Errors

enum WeatherAPIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case badRequest
    case unauthorized
    case notFound
    case rateLimitExceeded
    case serverError(Int)
    case httpError(Int)
    case networkError(Error)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .invalidResponse:
            return "無効なレスポンスです"
        case .badRequest:
            return "リクエストが正しくありません"
        case .unauthorized:
            return "APIキーが無効です"
        case .notFound:
            return "指定された場所が見つかりません"
        case .rateLimitExceeded:
            return "APIの利用制限を超えました。しばらく時間をおいて再度お試しください"
        case .serverError(let statusCode):
            return "サーバーエラーが発生しました: \(statusCode)"
        case .httpError(let statusCode):
            return "HTTPエラー: \(statusCode)"
        case .networkError(let error):
            return "ネットワークエラー: \(error.localizedDescription)"
        case .decodingError(let error):
            return "データの解析に失敗しました: \(error.localizedDescription)"
        }
    }
}
