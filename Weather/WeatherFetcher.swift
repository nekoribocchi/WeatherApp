import Foundation
import Combine
import SwiftUI

class WeatherFetcher: ObservableObject {
    @Published var cities: [(String, String, String)] = []  // 都道府県、都市名、ID
    @Published var weatherInfo: String = ""
    @Published var weatherIcon: String = ""
    @Published var weatherIconColor: Color = .white  // アイコンの色を白に設定
    @Published var selectedCityName: String = "天気情報"  // デフォルトの見出し
    private var cancellables = Set<AnyCancellable>()
    
    //Combineフレームワークのデータを取得するための部分
    func fetchCities() {
        // 1. 関数のセットアップ
        let urlString = "https://weather.tsukumijima.net/primary_area.xml"
        guard let url = URL(string: urlString) else { return }
        
        // 2. Publisherの生成
        URLSession.shared.dataTaskPublisher(for: url)
        
        // 3. Operatorsの設定
            .map { $0.data }
            .tryMap { data -> [(String, String, String)] in
                let parser = XMLParser(data: data)
                let delegate = WeatherXMLParserDelegate()
                parser.delegate = delegate
                if parser.parse() {
                    return delegate.cities
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .receive(on: DispatchQueue.main)
        
        // 4. Subscriberの設定
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] cities in
                self?.cities = cities
            })
            .store(in: &cancellables)
    }
    
    //指定された都市の天気情報を非同期で取得し、取得したデータを処理してUIを更新するための処理を行っています。
    func fetchWeather(for cityId: String, cityName: String) {
        
        // 1. 関数のセットアップ
        selectedCityName = cityName
        let urlString = "https://weather.tsukumijima.net/api/forecast/city/\(cityId)"
        guard let url = URL(string: urlString) else {
            weatherInfo = "Invalid URL"
            weatherIcon = ""
            return
        }
        
        //2. Publisherの生成
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
        
        //3. Operatorsの設定
            .map { response in
                (response.title, response.description.bodyText, response.forecasts.first?.telop ?? "")
            }
            .replaceError(with: ("Failed to fetch weather information.", "", ""))
            .receive(on: DispatchQueue.main)
        
        //4. Subscriberの設定
            .sink { [weak self] result in
                self?.weatherInfo = "\(result.1)"
                self?.weatherIcon = self?.iconForWeather(result.2) ?? ""
                self?.weatherIconColor = .white  // アイコンの色を設定
            }
            .store(in: &cancellables)
    }
    
    
    private func iconForWeather(_ weather: String) -> String {
        switch weather {
        case let w where w.contains("晴"):
            return "sun.max.fill"
        case let w where w.contains("曇"):
            return "cloud.fill"
        case let w where w.contains("雨"):
            return "cloud.rain.fill"
        case let w where w.contains("雪"):
            return "snow"
        default:
            return "questionmark.circle.fill"
        }
    }
}

