//
//  WeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/18.
//

import SwiftUI

// MARK: - WeatherView（MainViewのWeatherManagerを受け取る版）
struct WeatherView: View {
    @ObservedObject var weatherManager: WeatherManager
    
    var body: some View {
        VStack(spacing: 20) {
            // 更新ボタンを共通化
            refreshButton
            
            // レイアウトを整理し、コンテンツエリアを分離
            weatherContentView
        }
        .padding() // 全体のパディングを追加
    }
    
    // MARK: - 更新ボタン（冗長な処理を統合）
    private var refreshButton: some View {
        Button("更新") {
            // 両方のデータを一度に更新する処理を統合
            weatherManager.refreshAllWeatherData()
        }
        .buttonStyle(.borderedProminent)
    }
    
    // MARK: - 天気情報コンテンツエリア
    private var weatherContentView: some View {
        VStack(spacing: 16) { // スペーシングを統一
            // 気温データ表示
            temperatureSection
            
            // 予報データ表示
            forecastSection
            
            // UV・降水確率データ表示
            uvAndPrecipitationSection
        }
    }
    
    // MARK: - 気温セクション
    private var temperatureSection: some View {
        Group {
            if let forecast = weatherManager.forecastWeather,
               let weather = weatherManager.currentWeather {
                TemperatureView(forecast: forecast, weather: weather)
            } else {
                // エラー表示を共通化
                DataUnavailableView(
                    title: "気温データがありません"
                )
            }
        }
    }
    
    // MARK: - 予報セクション
    private var forecastSection: some View {
        Group {
            if let forecast = weatherManager.forecastWeather {
                ForecastView(forecast: forecast)
            } else {
                DataUnavailableView(
                    title: "予報データがありません"
                )
            }
        }
    }
    
    // MARK: - UV・降水確率セクション
    private var uvAndPrecipitationSection: some View {
        Group {
            if let oneCallAPI30 = weatherManager.oneCallAPI30 {
                HStack(spacing: 12) { // スペーシングを明示的に設定
                    UVView(uv: oneCallAPI30)
                    PopView(pop: oneCallAPI30)
                }
            } else {
                // 重複していたエラー表示を共通化し、適切なメッセージに変更
                DataUnavailableView(
                    title: "詳細データがありません"
                )
            }
        }
    }
    
    // MARK: - 気温データの状態メッセージを生成
    private var temperatureDataStatusMessage: String {
        switch (weatherManager.forecastWeather, weatherManager.currentWeather) {
        case (nil, nil):
            return "予報と現在の天気データが必要です"
        case (nil, _):
            return "予報データが不足しています"
        case (_, nil):
            return "現在の天気データが不足しています"
        default:
            return ""
        }
    }
}



// MARK: - Preview
#Preview {
    WeatherView(weatherManager: WeatherManager())
}
