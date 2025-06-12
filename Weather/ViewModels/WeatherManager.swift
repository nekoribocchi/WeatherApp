import Foundation
import CoreLocation

// MARK: - Weather Manager

class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published Properties
    /// 取得した現在の天気データ
    @Published var currentWeather: WeatherData?
    
    /// 取得した予報データ
    @Published var forecastWeather: ForecastData?
    
    /// ローディング状態
    @Published var isLoading = false
    
    /// エラーメッセージ
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    
    /// OpenWeatherMap APIキー
    private let apiKey: String = {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let key = plist["OpenWeatherAPIKey"] as? String,
           !key.isEmpty {
            return key
        }
        
        fatalError("API Key が設定されていません。Config.plistを作成してOpenWeatherAPIKeyを追加してください。")
    }()
    
    // MARK: - Initializer
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Public Methods
    
    /// 現在の天気を取得
    func getCurrentWeather() {
        isLoading = true
        errorMessage = ""
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    /// 5日間の予報を取得
    func getForecast() {
        guard let location = locationManager.location else {
            // 位置情報がない場合は先に位置情報を取得
            isLoading = true
            errorMessage = ""
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            return
        }
        
        fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // デフォルトでは現在の天気を取得
        fetchCurrentWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "位置情報の取得に失敗しました"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied:
            isLoading = false
            errorMessage = "位置情報の許可が必要です"
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    
    /// ジェネリックなデータ取得メソッド
    private func fetchData<T: Codable>(
        from apiType: WeatherAPIType,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let urlString = apiType.url(apiKey: apiKey)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [responseType] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    /// 現在の天気を取得
    private func fetchCurrentWeather(lat: Double, lon: Double) {
        let apiType = WeatherAPIType.current(lat: lat, lon: lon)
        
        fetchData(from: apiType, responseType: WeatherData.self) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let weatherData):
                self?.currentWeather = weatherData
                self?.errorMessage = ""
            case .failure(let error):
                self?.errorMessage = "天気データの取得に失敗しました: \(error.localizedDescription)"
            }
        }
    }
    
    /// 5日間の予報を取得
    private func fetchForecast(lat: Double, lon: Double) {
        isLoading = true
        let apiType = WeatherAPIType.forecast(lat: lat, lon: lon)
        
        fetchData(from: apiType, responseType: ForecastData.self) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let forecastData):
                self?.forecastWeather = forecastData
                self?.errorMessage = ""
            case .failure(let error):
                self?.errorMessage = "予報データの取得に失敗しました: \(error.localizedDescription)"
            }
        }
    }
}
