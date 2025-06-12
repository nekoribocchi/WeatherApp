//
//  WeatherData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//

import Foundation
// MARK: - Models
struct WeatherData: Codable {
    let name: String //tokyo
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: String         // 天気の種類（例："Clouds" "Rain"）
        let description: String  // 日本語での説明（例："くもり"）
        let icon: String         // アイコンのID（例："04d"）
    }
}
/*
 WeatherData
 ├── name: "Tokyo"
 ├── main
 │   ├── temp: 25.4
 │   └── humidity: 64
 └── weather (配列)
     └── [0]
         ├── main: "Clouds"
         ├── description: "くもり"
         └── icon: "04d"

 */
