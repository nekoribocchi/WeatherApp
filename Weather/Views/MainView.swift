// MainView.swift
// メインのビューコントローラー - アプリの中心的な画面を管理

import SwiftUI

struct MainView: View {
    // MARK: - Properties
    @StateObject private var weatherManager = WeatherManager()
    @State private var selectedTab: Int = 0
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack{
                if weatherManager.isLoading {
                    LoadingView()
                } else if !weatherManager.errorMessage.isEmpty {
                    ErrorView(
                        errorMessage: weatherManager.errorMessage,
                        onRetry: handleRetry
                    )
                } else {
                    MainTabView(
                        weatherManager: weatherManager,
                        selectedTab: $selectedTab
                    )
                }
            }
            .onAppear {
                initializeWeatherData()
            }
        }
    }
    
    // MARK: - Private Methods
    func initializeWeatherData() {
        print("🚀 アプリ起動時の天気データ初期化を開始")
        weatherManager.getCurrentWeather()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    print("📅 天気予報データを取得中...")
                    self.weatherManager.getForecast()
                }
    }
    
    /// エラー状態からのリトライ処理
    private func handleRetry() {
        print("🔄 エラーからのリトライを実行")
        weatherManager.clearError()
        refreshCurrentTabData()
    }
    
    /// 現在選択中のタブに応じたデータ更新
    private func refreshCurrentTabData() {
        print("🔄 現在のタブ(\(selectedTab))のデータを更新")
        refreshTabData(for: selectedTab)
    }
    
    /// 指定されたタブのデータ更新処理
    /// - Parameter tab: 更新対象のタブインデックス
    private func refreshTabData(for tab: Int) {
        print("🔄 タブ \(tab) のデータ更新を開始")
        
        switch tab {
        case 0: // Clothesタブ
            print("👕 服装推薦用の天気データを取得")
            weatherManager.getCurrentWeather()
            
        case 1: // Weatherタブ
            print("🌤️ 詳細天気情報を取得")
            // 修正: 予報と現在天気の両方を取得（重複を避けるため順序を最適化）
            weatherManager.getForecast()
            weatherManager.getCurrentWeather()
            
        default:
            print("⚠️ 未定義のタブが選択されました: \(tab)")
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        MainView()
    }
}
