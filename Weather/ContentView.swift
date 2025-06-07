import SwiftUI
import CoreLocation

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

// MARK: - Weather Manager
class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let locationManager = CLLocationManager()
    private let apiKey: String = {
        // Config.plist から読み込み（推奨）
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let key = plist["OpenWeatherAPIKey"] as? String,
           !key.isEmpty {
            return key
        }
        
        fatalError("API Key が設定されていません。Config.plistを作成してOpenWeatherAPIKeyを追加してください。")
    }()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getWeather() {
        isLoading = true
        errorMessage = ""
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "位置情報の取得に失敗しました"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else if status == .denied {
            isLoading = false
            errorMessage = "位置情報の許可が必要です"
        }
    }
    
    // MARK: - Weather API
    private func fetchWeather(lat: Double, lon: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=ja"
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "URLエラー"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "通信エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "データが取得できませんでした"
                    return
                }
                
                do {
                    self.weather = try JSONDecoder().decode(WeatherData.self, from: data)
                } catch {
                    self.errorMessage = "データの解析に失敗しました"
                }
            }
        }.resume()
    }
}

// MARK: - Main View
struct ContentView: View {
    @StateObject private var weatherManager = WeatherManager()
    
    var body: some View {
        VStack(spacing: 30) {
            if weatherManager.isLoading {
                ProgressView("読み込み中...")
                    .scaleEffect(1.2)
            } else if let weather = weatherManager.weather {
                WeatherView(weather: weather)
            } else if !weatherManager.errorMessage.isEmpty {
                ErrorView(message: weatherManager.errorMessage) {
                    weatherManager.getWeather()
                }
            } else {
                StartView {
                    weatherManager.getWeather()
                }
            }
        }
    }
}

// MARK: - Weather Display View
struct WeatherView: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 20) {
            Text(weather.name)
                .font(.title)
                .fontWeight(.semibold)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "cloud")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
            }
            .frame(width: 100, height: 100)
            
            Text("\(Int(weather.main.temp))°C")
                .font(.system(size: 60, weight: .light))
            
            Text(weather.weather.first?.description ?? "")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("湿度: \(weather.main.humidity)%")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Start View
struct StartView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("現在地の天気を表示")
                .font(.title2)
                .fontWeight(.medium)
            
            Button(action: action) {
                Text("天気を取得")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("エラー")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: retry) {
                Text("再試行")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}
