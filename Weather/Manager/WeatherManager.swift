import Foundation
import CoreLocation

// MARK: - Weather Manager

@MainActor
class WeatherManager: ObservableObject {
    
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
    
    private let apiService: WeatherAPIServiceProtocol
    private let locationService: LocationService
    
    // MARK: - Initializer
    
    init(
        apiService: WeatherAPIServiceProtocol? = nil,
        locationService: LocationService? = nil
    ) {
        // APIキーの取得
        let apiKey: String = {
            if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
               let plist = NSDictionary(contentsOfFile: path),
               let key = plist["OpenWeatherAPIKey"] as? String,
               !key.isEmpty {
                return key
            }
            
            fatalError("API Key が設定されていません。Config.plistを作成してOpenWeatherAPIKeyを追加してください。")
        }()
        
        // 依存性の注入（テスト時にモックを注入可能）
        self.apiService = apiService ?? WeatherAPIService(apiKey: apiKey)
        self.locationService = locationService ?? LocationService()
    }
    
    // MARK: - Public Methods
    
    /// 現在地の天気を取得
    func getCurrentWeather() {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                // 位置情報の許可状態をチェック
                switch self.locationService.authorizationStatus {
                case .notDetermined:
                    self.locationService.requestLocationPermission()
                    throw LocationError.permissionNotDetermined
                case .denied, .restricted:
                    throw LocationError.permissionDenied
                case .authorizedWhenInUse, .authorizedAlways:
                    break
                @unknown default:
                    throw LocationError.unknown
                }
                
                // 現在位置を取得
                let location = try await self.locationService.getCurrentLocation()
                
                // 天気データを取得
                let weatherData = try await self.apiService.fetchCurrentWeather(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
                
                self.currentWeather = weatherData
            }
        }
    }
    
    /// 3時間予報を取得
    func getForecast() {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                // 位置情報の許可状態をチェック
                switch self.locationService.authorizationStatus {
                case .notDetermined:
                    self.locationService.requestLocationPermission()
                    throw LocationError.permissionNotDetermined
                case .denied, .restricted:
                    throw LocationError.permissionDenied
                case .authorizedWhenInUse, .authorizedAlways:
                    break
                @unknown default:
                    throw LocationError.unknown
                }
                
                // 位置情報の取得
                let location = try await self.locationService.getCurrentLocation()
                
                // 予報データを取得
                let forecastData = try await self.apiService.fetchForecast(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
                
                self.forecastWeather = forecastData
            }
        }
    }
    
    /// 指定した座標の現在の天気を取得
    func getCurrentWeather(lat: Double, lon: Double) {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                let weatherData = try await self.apiService.fetchCurrentWeather(lat: lat, lon: lon)
                self.currentWeather = weatherData
            }
        }
    }
    
    /// 指定した座標の5日間予報を取得
    func getForecast(lat: Double, lon: Double) {
        Task {
            await performWeatherRequest { [weak self] in
                guard let self = self else { return }
                
                let forecastData = try await self.apiService.fetchForecast(lat: lat, lon: lon)
                self.forecastWeather = forecastData
            }
        }
    }
    
    /// エラーメッセージをクリア
    func clearError() {
        errorMessage = ""
    }
    
    // MARK: - Private Methods
    
    /// 天気データリクエストの共通処理
    private func performWeatherRequest(_ request: () async throws -> Void) async {
        isLoading = true
        errorMessage = ""
        
        do {
            try await request()
        } catch let error as WeatherAPIError {
            errorMessage = error.localizedDescription
        } catch let error as LocationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "予期しないエラーが発生しました: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
