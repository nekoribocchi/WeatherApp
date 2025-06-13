//
//  WeatherAPIService.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation

// MARK: - Weather API Types

enum WeatherAPIType {
    case current(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    
    func url(apiKey: String) -> String {
        let baseURL = "https://api.openweathermap.org/data/2.5"
        let commonParams = "&appid=\(apiKey)&units=metric&lang=ja"
        
        switch self {
        case .current(let lat, let lon):
            return "\(baseURL)/weather?lat=\(lat)&lon=\(lon)\(commonParams)"
        case .forecast(let lat, let lon):
            return "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)\(commonParams)"
        }
    }
}

// MARK: - Weather API Service

protocol WeatherAPIServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherData
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastData
}

class WeatherAPIService: WeatherAPIServiceProtocol {
    
    // MARK: - Properties
    
    private let apiKey: String
    private let session: URLSession
    
    // MARK: - Initializer
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: - Public Methods
    
    /// 現在の天気を取得
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherData {
        let apiType = WeatherAPIType.current(lat: lat, lon: lon)
        return try await fetchData(from: apiType, responseType: WeatherData.self)
    }
    
    /// 5日間の予報を取得
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastData {
        let apiType = WeatherAPIType.forecast(lat: lat, lon: lon)
        return try await fetchData(from: apiType, responseType: ForecastData.self)
    }
    
    // MARK: - Private Methods
    
    /// ジェネリックなデータ取得メソッド
    private func fetchData<T: Codable>(
        from apiType: WeatherAPIType,
        responseType: T.Type
    ) async throws -> T {
        let urlString = apiType.url(apiKey: apiKey)
        
        guard let url = URL(string: urlString) else {
            throw WeatherAPIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherAPIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break // 成功
            case 400:
                throw WeatherAPIError.badRequest
            case 401:
                throw WeatherAPIError.unauthorized
            case 404:
                throw WeatherAPIError.notFound
            case 429:
                throw WeatherAPIError.rateLimitExceeded
            case 500...599:
                throw WeatherAPIError.serverError(httpResponse.statusCode)
            default:
                throw WeatherAPIError.httpError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(responseType, from: data)
        } catch {
            if let weatherError = error as? WeatherAPIError {
                throw weatherError
            } else if error is DecodingError {
                throw WeatherAPIError.decodingError(error)
            } else {
                throw WeatherAPIError.networkError(error)
            }
        }
    }
}

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
