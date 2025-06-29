//
//  SwiftUIView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//

// MainTabView.swift
// タブビューの実装 - メインコンテンツエリアを管理

import SwiftUI

struct MainTabView: View {
    // MARK: - Properties
    let weatherManager: WeatherManager
    @Binding var selectedTab: Int
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                if let weather = weatherManager.currentWeather, let oneCall = weatherManager.oneCallAPI30 {
                    ClothesView(weatherManager: weatherManager, weather: weather, oneCall: oneCall)
                } else {
                    Text("天気データがありません")
                }
            }
            .tabItem {
                Image(systemName: "tshirt.fill")
                Text("Clothes")
            }
            .tag(0)
            
            WeatherView(weatherManager: weatherManager)
                .tabItem {
                    Image(systemName: "cloud")
                    Text("Weather")
                }
                .tag(1)
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var selectedTab = 0
    let weatherManager = WeatherManager()
    
    return MainTabView(
        weatherManager: weatherManager,
        selectedTab: $selectedTab
    )
}
