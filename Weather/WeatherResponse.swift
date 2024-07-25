import Foundation

struct WeatherResponse: Decodable {
    struct Description: Decodable {
        let bodyText: String
    }
    let title: String
    let description: Description
    let forecasts: [Forecast]
    
    struct Forecast: Decodable {
        let dateLabel: String
        let telop: String
    }
}
