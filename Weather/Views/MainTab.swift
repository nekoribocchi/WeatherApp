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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Body
    var body: some View {
        if horizontalSizeClass == .compact {
            // iPhone: TabView
            TabView(selection: $selectedTab) {
                clothesTabItem
                weatherTabItem
            }
        } else {
            // iPad: NavigationSplitView
            NavigationSplitView {
                List {
                    Label("Clothes", systemImage: "tshirt.fill")
                        .onTapGesture { selectedTab = 0 }
                        .listRowBackground(selectedTab == 0 ? Color.accentColor.opacity(0.2) : Color.clear)
                    Label("Weather", systemImage: "cloud")
                        .onTapGesture { selectedTab = 1 }
                        .listRowBackground(selectedTab == 1 ? Color.accentColor.opacity(0.2) : Color.clear)
                }
                .navigationTitle("Weather")
            } detail: {
                switch selectedTab {
                case 0:
                    clothesView
                default:
                    weatherView
                }
            }
        }
    }

    private var clothesTabItem: some View {
        clothesView
            .tabItem {
                Image(systemName: "tshirt.fill")
                Text("Clothes")
            }
            .tag(0)
    }

    private var weatherTabItem: some View {
        weatherView
            .tabItem {
                Image(systemName: "cloud")
                Text("Weather")
            }
            .tag(1)
    }

    private var clothesView: some View {
        Group {
            if let weather = weatherManager.currentWeather, let oneCall = weatherManager.oneCallAPI30 {
                ClothesView(weatherManager: weatherManager, weather: weather, oneCall: oneCall)
            } else {
                Text("天気データがありません")
            }
        }
    }

    private var weatherView: some View {
        WeatherView(weatherManager: weatherManager)
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

