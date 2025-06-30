//
//  MockData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import Foundation
// MARK: - Mock Data Extensions for Previews

extension CurrentWeatherAPI25 {
    static let mockData = CurrentWeatherAPI25(
        name: "東京",
        main: Main(
            temp: 25.0,
            feels_like: 27.0,
            temp_min: 20.0,
            temp_max: 30.0,
        ),
        weather: [
            Weather(
                id: 800,
                main: "Clear",
                description: "快晴",
                icon: "01d"
            )
        ],
        dt: Int(Date().timeIntervalSince1970),
    )
    
    static let mockRainyData = CurrentWeatherAPI25(
        name: "大阪",
        main: Main(
            temp: 18.0,
            feels_like: 35.0,
            temp_min: 15.0,
            temp_max: 22.0,
        ),
        weather: [
            Weather(
                id: 500,
                main: "Rain",
                description: "小雨",
                icon: "10d"
            )
        ],
        dt: Int(Date().timeIntervalSince1970),
    )
}

// MARK: - Mock Data(ForecastAPI25)
extension ForecastAPI25 {
    static let mockData = ForecastAPI25(
        cod: "200",
        message: 0,
        cnt: 5,
        list: [
            ForecastItem.mockSunnyItem,
            ForecastItem.mockCloudyItem,
            ForecastItem.mockRainyItem,
            ForecastItem.mockSunnyItem,
            ForecastItem.mockCloudyItem
        ],
        city: City(
            id: 1850147,
            name: "東京",
            coord: City.Coord(lat: 35.6762, lon: 139.6503),
            country: "JP",
            population: 13929286,
            timezone: 32400,
            sunrise: 1671834000,
            sunset: 1671868800
        )
    )
    
    static let mockEmptyData = ForecastAPI25(
        cod: "200",
        message: 0,
        cnt: 0,
        list: [],
        city: City(
            id: 1850147,
            name: "東京",
            coord: City.Coord(lat: 35.6762, lon: 139.6503),
            country: "JP",
            population: 13929286,
            timezone: 32400,
            sunrise: 1671834000,
            sunset: 1671868800
        )
    )
}

extension ForecastAPI25.ForecastItem {
    static let mockSunnyItem = ForecastAPI25.ForecastItem(
        dt: Int(Date().timeIntervalSince1970) + 86400,
        main: Main(
            temp: 26.0,
            feels_like: 28.0,
            temp_min: 22.0,
            temp_max: 30.0,
            pressure: 1015,
            sea_level: 1015,
            grnd_level: 1012,
            humidity: 55,
            temp_kf: 0.0
        ),
        weather: [
            Weather(
                id: 800,
                main: "Clear",
                description: "快晴",
                icon: "01d"
            )
        ],
        clouds: Clouds(all: 5),
        wind: Wind(speed: 2.5, deg: 200, gust: nil),
        visibility: 10000,
        pop: 0.1,
        dt_txt: "2024-06-13 12:00:00"
    )
    
    static let mockCloudyItem = ForecastAPI25.ForecastItem(
        dt: Int(Date().timeIntervalSince1970) + 172800,
        main: Main(
            temp: 22.0,
            feels_like: 23.0,
            temp_min: 18.0,
            temp_max: 25.0,
            pressure: 1010,
            sea_level: 1010,
            grnd_level: 1007,
            humidity: 70,
            temp_kf: 0.0
        ),
        weather: [
            Weather(
                id: 803,
                main: "Clouds",
                description: "曇り",
                icon: "04d"
            )
        ],
        clouds: Clouds(all: 75),
        wind: Wind(speed: 1.8, deg: 120, gust: nil),
        visibility: 10000,
        pop: 0.3,
        dt_txt: "2024-06-14 12:00:00"
    )
    
    static let mockRainyItem = ForecastAPI25.ForecastItem(
        dt: Int(Date().timeIntervalSince1970) + 259200,
        main: Main(
            temp: 19.0,
            feels_like: 17.0,
            temp_min: 16.0,
            temp_max: 22.0,
            pressure: 1005,
            sea_level: 1005,
            grnd_level: 1002,
            humidity: 88,
            temp_kf: 0.0
        ),
        weather: [
            Weather(
                id: 500,
                main: "Rain",
                description: "小雨",
                icon: "10d"
            )
        ],
        clouds: Clouds(all: 90),
        wind: Wind(speed: 3.2, deg: 80, gust: 4.5),
        visibility: 8000,
        pop: 0.8,
        dt_txt: "2024-06-15 12:00:00"
    )
}
