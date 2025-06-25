//
//  ForecastItemView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI


/// MARK: - ForecastItemView
struct ForecastItemView: View {
    let item: ForecastAPI25.ForecastItem
    
    var body: some View {
        VStack(spacing: 8) {
            // 時間
            Text(formattedTime)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            // 天気アイコン
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(item.weather.first?.icon ?? "01d")@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "cloud")
                    .foregroundColor(.gray)
            }
            .frame(width: 30, height: 30)
            
            // 気温
            Text("\(Int(item.main.temp))°C")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("\(Int(item.pop * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
        }
        .frame(minWidth: 40)
    }
    
    // 時間をフォーマット（UnixタイムスタンプをHH形式に変換）
    private var formattedTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
}

#Preview("Forecast Item - Sunny") {
    ForecastItemView(item: ForecastAPI25.ForecastItem.mockSunnyItem)
        .padding()
}

#Preview("Forecast Item - Cloudy") {
    ForecastItemView(item: ForecastAPI25.ForecastItem.mockCloudyItem)
        .padding()
}

#Preview("Forecast Items - Multiple") {
    HStack {
        ForecastItemView(item: ForecastAPI25.ForecastItem.mockSunnyItem)
        ForecastItemView(item: ForecastAPI25.ForecastItem.mockCloudyItem)
        ForecastItemView(item: ForecastAPI25.ForecastItem.mockRainyItem)
    }
    .padding()
}
