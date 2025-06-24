import Foundation
import WeatherKit
import CoreLocation

/// UV指数を取得・管理するクラス
/// WeatherKitを使用して現在地のUV指数を取得する責任を持つ
@MainActor
class UVIndexManager2: ObservableObject {
    
    // MARK: - Properties
    
    /// 現在のUV指数値（外部から読み取り専用）
    @Published private(set) var currentUVIndex: Double?
    
    /// エラーメッセージ（外部から読み取り専用）
    @Published private(set) var errorMessage: String?
    
    /// 読み込み中の状態（外部から読み取り専用）
    @Published private(set) var isLoading: Bool = false
    
    /// WeatherKitのサービスインスタンス
    private let weatherService = WeatherService.shared
    
    /// 位置情報管理用のマネージャー
    private let locationManager = CLLocationManager()
    
    // MARK: - Initialization
    
    /// 初期化時に位置情報の許可をリクエスト
    init() {
        requestLocationPermission()
    }
    
    // MARK: - Public Methods
    
    /// 今日のUV指数を取得するメソッド
    /// - Parameter location: 取得したい位置（CLLocationオブジェクト）
    func fetchTodayUVIndex(for location: CLLocation) async {
        // UI更新は必ずメインスレッドで実行
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            currentUVIndex = nil
        }
        
        do {
            // WeatherKitから今日の天気データを取得
            let weather = try await weatherService.weather(for: location)
            
            // 今日の日付を取得
            let today = Calendar.current.startOfDay(for: Date())
            
            // 今日のUV指数を検索
            let todayUVIndex = weather.dailyForecast.first { dailyWeather in
                Calendar.current.isDate(dailyWeather.date, inSameDayAs: today)
            }.map { Double($0.uvIndex.value) }
            
            // メインスレッドでUI更新
            await MainActor.run {
                self.currentUVIndex = todayUVIndex
                self.isLoading = false
            }
            
        } catch {
            // エラーハンドリング
            await MainActor.run {
                self.errorMessage = "UV指数の取得に失敗しました: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// 現在地のUV指数を取得するメソッド
    func fetchCurrentLocationUVIndex() async {
        guard let location = getCurrentLocation() else {
            await MainActor.run {
                self.errorMessage = "位置情報を取得できませんでした"
                self.isLoading = false
            }
            return
        }
        
        await fetchTodayUVIndex(for: location)
    }
    
    // MARK: - Private Methods
    
    /// 位置情報の使用許可をリクエストする
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 現在地を取得する（簡易実装）
    private func getCurrentLocation() -> CLLocation? {
        // 実際のアプリでは、CLLocationManagerのデリゲートを使用して
        // より適切に位置情報を取得することを推奨します
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
              locationManager.authorizationStatus == .authorizedAlways else {
            return nil
        }
        
        // デモ用の東京の座標を返す（実際は locationManager.location を使用）
        return CLLocation(latitude: 35.6762, longitude: 139.6503)
    }
}
import SwiftUI
import CoreLocation

/// メイン画面のビュー
/// UV指数の表示とボタンによる取得操作を提供
struct ContentView: View {
    
    // MARK: - Properties
    
    /// UV指数管理クラスのインスタンス
    @StateObject private var uvManager = UVIndexManager2()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // UV指数表示エリア
                uvIndexDisplaySection
                
                // ボタンエリア
                buttonSection
                
                Spacer()
            }
            .padding()
            .navigationTitle("UV指数チェッカー")
        }
    }
    
    // MARK: - View Components
    
    /// UV指数表示セクション
    private var uvIndexDisplaySection: some View {
        VStack(spacing: 15) {
            Text("今日のUV指数")
                .font(.title2)
                .fontWeight(.semibold)
            
            if uvManager.isLoading {
                ProgressView("取得中...")
                    .scaleEffect(1.2)
                    .padding()
            } else if let uvIndex = uvManager.currentUVIndex {
                VStack(spacing: 10) {
                    Text("\(uvIndex, specifier: "%.1f")")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(uvIndexColor(for: uvIndex))
                    
                    Text(uvIndexDescription(for: uvIndex))
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 5)
                )
            } else if let error = uvManager.errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text(error)
                        .font(.body)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "sun.max")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("UV指数を取得してください")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
    }
    
    /// ボタンセクション
    private var buttonSection: some View {
        Button(action: {
            Task {
                await uvManager.fetchCurrentLocationUVIndex()
            }
        }) {
            HStack {
                Image(systemName: "location")
                Text("現在地のUV指数を取得")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .disabled(uvManager.isLoading)
    }
    
    // MARK: - Helper Methods
    
    /// UV指数に応じた色を返す
    private func uvIndexColor(for uvIndex: Double) -> Color {
        switch uvIndex {
        case 0..<3:
            return .green
        case 3..<6:
            return .yellow
        case 6..<8:
            return .orange
        case 8..<11:
            return .red
        default:
            return .purple
        }
    }
    
    /// UV指数に応じた説明文を返す
    private func uvIndexDescription(for uvIndex: Double) -> String {
        switch uvIndex {
        case 0..<3:
            return "弱い"
        case 3..<6:
            return "中程度"
        case 6..<8:
            return "強い"
        case 8..<11:
            return "非常に強い"
        default:
            return "極めて強い"
        }
    }
}



#Preview {
    NavigationView {
        ContentView()
    }
}
