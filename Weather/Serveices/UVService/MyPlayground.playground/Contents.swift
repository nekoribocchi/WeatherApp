import WeatherKit
import CoreLocation


let weatherService = WeatherService()

let syracuse = CLLocation(latitude: 43.0481, longitude: -76.1474)

let weather = try! await weatherService.weather(for: syracuse)

let temperature = weather.currentWeather.temperature

let uvIndex = weather.currentWeather.uvIndex

print(uvIndex)
