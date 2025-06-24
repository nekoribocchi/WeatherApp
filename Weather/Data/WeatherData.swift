//
//  WeatherData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//
import Foundation

// MARK: - Weather Models

/// 現在の天気データ
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind?
    let dt: Int
    let timezone: Int
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int?
    }
}
