//
//  WeatherData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//

import Foundation
// MARK: - Models
struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
    
    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
}
