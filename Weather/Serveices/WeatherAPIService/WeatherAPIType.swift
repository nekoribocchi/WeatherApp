//
//  WeatherAPIType.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import Foundation
// MARK: - Weather API Types

// This method return url tailored to each case
enum WeatherAPIType {
    case current(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)
    case uv(lat: Double, lon: Double)
    
    func url(apiKey: String) -> String {
        let baseURL2_5 = "https://api.openweathermap.org/data/2.5"
        let baseURL3 = "https://api.openweathermap.org/data/3.0/onecall?"
        let commonParams = "&appid=\(apiKey)&units=metric&lang=ja"

        switch self {
        case .current(let lat, let lon):
            return "\(baseURL2_5)/weather?lat=\(lat)&lon=\(lon)\(commonParams)"
        case .forecast(let lat, let lon):
            return "\(baseURL2_5)/forecast?lat=\(lat)&lon=\(lon)\(commonParams)"
        case .uv(let lat, let lon):
            return "\(baseURL3)lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        }
    }
}
