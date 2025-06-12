//
//  WeatherAPIType.swift
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
