//
//  TabStyleView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/10.
//

import SwiftUI

struct TabStyleView: View {
    var body: some View {
        TabView {
            // Clothesタブ
            ClothesView(weather: WeatherData(main: WeatherData.Main(temp: 25.0, humidity: 60), weather: [WeatherData.Weather(main: "Clear", description: "晴れ", icon: "01d")], name: "Tokyo"))
                .tabItem {
                    Image(systemName: "tshirt")
                    Text("Clothes")
                }
            // Weatherタブ
            WeatherView()
                .tabItem {
                    Image(systemName: "cloud.fill")
                    Text("Clothes")
                }
            
        }
        
    }
}
#Preview {
    TabStyleView()
}

