//
//  CurrentWeatherAPI25.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//
import Foundation

// MARK: - Weather Models

/// 現在の天気データ
struct CurrentWeatherAPI25: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let dt: Int
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
