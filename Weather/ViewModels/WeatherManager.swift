//
//  WeatherManager.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//
import Foundation
import CoreLocation

// MARK: - Weather Manager
/**
 * 天気情報を管理するクラス
 * - 位置情報を取得して現在地の天気を取得
 * - OpenWeatherMap APIを使用
 * - SwiftUIのObservableObjectプロトコルに準拠
 */
class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Published Properties
    /// 取得した天気データ（SwiftUIで監視される）
    @Published var weather: WeatherData?
    
    /// ローディング状態（SwiftUIで監視される）
    @Published var isLoading = false
    
    /// エラーメッセージ（SwiftUIで監視される）
    @Published var errorMessage = ""
    
    // MARK: - Private Properties
    /// 位置情報管理用のマネージャー
    private let locationManager = CLLocationManager()
    
    /// OpenWeatherMap APIキー
    /// Config.plistファイルから読み込む
    private let apiKey: String = {
        // Config.plistファイルのパスを取得
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           // plistファイルを辞書として読み込み
           let plist = NSDictionary(contentsOfFile: path),
           // "OpenWeatherAPIKey"キーの値を取得
           let key = plist["OpenWeatherAPIKey"] as? String,
           // キーが空でないことを確認
           !key.isEmpty {
            return key
        }
        
        // APIキーが設定されていない場合はアプリを強制終了
        fatalError("API Key が設定されていません。Config.plistを作成してOpenWeatherAPIKeyを追加してください。")
    }()
    
    // MARK: - Initializer
    /// 初期化処理
    override init() {
        super.init()
        // 位置情報マネージャーの設定
        locationManager.delegate = self  // デリゲートを自分に設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 最高精度で位置情報を取得
    }
    
    // MARK: - Public Methods
    /**
     * 天気情報を取得する（外部から呼び出される関数）
     * 1. ローディング開始
     * 2. 位置情報の許可をリクエスト
     * 3. 現在位置を取得
     */
    func getWeather() {
        isLoading = true           // ローディング開始
        errorMessage = ""          // エラーメッセージをクリア
        locationManager.requestWhenInUseAuthorization()  // 位置情報の許可をリクエスト
        locationManager.requestLocation()                // 現在位置の取得を開始
    }
    
    // MARK: - Location Manager Delegate Methods
    /**
     * 位置情報の取得に成功した時に呼ばれる
     * @param manager: 位置情報マネージャー
     * @param locations: 取得した位置情報の配列
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最初の位置情報を取得
        guard let location = locations.first else { return }
        
        // 取得した緯度・経度で天気情報を取得
        fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
    
    /**
     * 位置情報の取得に失敗した時に呼ばれる
     * @param manager: 位置情報マネージャー
     * @param error: エラー情報
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false                      // ローディング終了
        errorMessage = "位置情報の取得に失敗しました"  // エラーメッセージを設定
    }
    
    /**
     * 位置情報の許可状態が変更された時に呼ばれる
     * @param manager: 位置情報マネージャー
     * @param status: 新しい許可状態
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 許可が得られた場合：位置情報の取得を開始
            locationManager.requestLocation()
        case .denied:
            // 許可が拒否された場合：エラー状態に設定
            isLoading = false
            errorMessage = "位置情報の許可が必要です"
        default:
            // その他の状態（未決定など）は何もしない
            break
        }
    }
    
    // MARK: - Private Methods
    /**
     * 指定された緯度・経度の天気情報をAPIから取得する
     * @param lat: 緯度
     * @param lon: 経度
     */
    private func fetchWeather(lat: Double, lon: Double) {
        // OpenWeatherMap APIのURLを構築
        // - units=metric: 摂氏温度で取得
        // - lang=ja: 日本語で取得
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=ja"
        
        // URLの作成をチェック
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "URLエラー"
            return
        }
        
        // APIリクエストを実行
        URLSession.shared.dataTask(with: url) { data, response, error in
            // メインスレッドでUI更新処理を実行
            DispatchQueue.main.async {
                self.isLoading = false  // ローディング終了
                
                // 通信エラーのチェック
                if let error = error {
                    self.errorMessage = "通信エラー: \(error.localizedDescription)"
                    return
                }
                
                // レスポンスデータの存在チェック
                guard let data = data else {
                    self.errorMessage = "データが取得できませんでした"
                    return
                }
                
                // JSONデータをWeatherDataオブジェクトに変換
                do {
                    self.weather = try JSONDecoder().decode(WeatherData.self, from: data)
                } catch {
                    self.errorMessage = "データの解析に失敗しました"
                }
            }
        }.resume()  // データタスクを開始
    }
}
