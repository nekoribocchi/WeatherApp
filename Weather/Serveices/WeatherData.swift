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

/// 5日間予報データ
struct ForecastData: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
    
    struct ForecastItem: Codable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let dt_txt: String
        
        struct Main: Codable {
            let temp: Double
            let feels_like: Double
            let temp_min: Double
            let temp_max: Double
            let pressure: Int
            let sea_level: Int
            let grnd_level: Int
            let humidity: Int
            let temp_kf: Double
        }
        
        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct Clouds: Codable {
            let all: Int
        }
        
        struct Wind: Codable {
            let speed: Double
            let deg: Int
            let gust: Double?
        }
    }
    
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        struct Coord: Codable {
            let lat: Double
            let lon: Double
        }
    }
}

