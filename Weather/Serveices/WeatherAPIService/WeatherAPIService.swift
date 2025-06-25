//
//  WeatherAPIType.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
import Playgrounds

// MARK: - Weather API Service

protocol WeatherAPIServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherAPI25
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastAPI25
    func fetchUV(lat: Double, lon: Double) async throws -> OneCallAPI30
}

// MARK: - Weather API Service

/// OpenWeatherMap APIとの通信を担当するサービスクラス
class WeatherAPIService: WeatherAPIServiceProtocol {

    // MARK: - Properties
    
    private let apiKey: String
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameters:
    ///   - apiKey: OpenWeatherMap APIキー
    ///   - session: URLSession（テスト時にモックセッションを注入可能）
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: - Public Methods
    
    /// 現在の天気を取得
    /// - Parameters:
    ///   - lat: 緯度
    ///   - lon: 経度
    /// - Returns: CurrentWeatherAPI25構造体
    /// - Throws: WeatherAPIError
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherAPI25 {
        let apiType = WeatherAPIType.current(lat: lat, lon: lon)
        return try await fetchData(from: apiType, responseType: CurrentWeatherAPI25.self)
    }
    
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastAPI25 {
        let apiType = WeatherAPIType.forecast(lat: lat, lon: lon)
        return try await fetchData(from: apiType, responseType: ForecastAPI25.self)
    }
    
    func fetchUV(lat: Double, lon: Double) async throws -> OneCallAPI30 {
        let apiType = WeatherAPIType.uv(lat: lat, lon: lon)
        return try await fetchData(from: apiType, responseType: OneCallAPI30.self)
    }
    
    // MARK: - Private Methods
    /// - JSONからCurrentWeatherAPI25/ForecastAPI25にデコードするメソッド
    /// - T: Codable Codableに準拠している型じゃないとダメ
    /// - Parameters:
    ///   - apiType: APIタイプ（現在の天気 or 予報）
    ///   - responseType: レスポンスの型
    /// - Returns: デコードされたデータ
    /// - Throws: WeatherAPIError
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
            try validateHTTPResponse(httpResponse)
            
            return try decoder.decode(responseType, from: data)
        } catch {
            throw mapError(error)
        }
    }
    
    /// HTTPレスポンスのステータスコードを検証
    /// - Parameter httpResponse: HTTPURLResponse
    /// - Throws: WeatherAPIError
    private func validateHTTPResponse(_ httpResponse: HTTPURLResponse) throws {
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
    }
    
    /// エラーをWeatherAPIErrorにマッピング
    /// - Parameter error: 元のエラー
    /// - Returns: WeatherAPIError
    private func mapError(_ error: Error) -> WeatherAPIError {
        if let weatherError = error as? WeatherAPIError {
            return weatherError
        } else if error is DecodingError {
            return WeatherAPIError.decodingError(error)
        } else {
            return WeatherAPIError.networkError(error)
        }
    }
}


#Playground {
    let apiKey =  WeatherManager.getAPIKey()
    let service = WeatherAPIService(apiKey: apiKey)
    let weather = try await service.fetchCurrentWeather(lat: 35.6895, lon: 139.6917)
    let forecast = try await service.fetchForecast(lat: 35.6895, lon: 139.6917)
}
