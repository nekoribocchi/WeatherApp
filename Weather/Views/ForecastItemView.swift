//
//  ForecastItemView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/12.
//

import SwiftUI


// MARK: - ForecastItemView
struct ForecastItemView: View {
    let item: ForecastData.ForecastItem
    
    private var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        //return formatter.string(from: date)
        return item.dt_txt
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(formattedDate)
                .font(.caption)
                .fontWeight(.medium)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(item.weather.first?.icon ?? "01d").png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .scaleEffect(0.5)
            }
            .frame(width: 40, height: 40)
            
            Text("\(Int(item.main.temp))°")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text("\(Int(item.pop * 100))%")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview("Forecast Item - Sunny") {
    ForecastItemView(item: ForecastData.ForecastItem.mockSunnyItem)
        .padding()
}

#Preview("Forecast Item - Cloudy") {
    ForecastItemView(item: ForecastData.ForecastItem.mockCloudyItem)
        .padding()
}

#Preview("Forecast Items - Multiple") {
    HStack {
        ForecastItemView(item: ForecastData.ForecastItem.mockSunnyItem)
        ForecastItemView(item: ForecastData.ForecastItem.mockCloudyItem)
        ForecastItemView(item: ForecastData.ForecastItem.mockRainyItem)
    }
    .padding()
}
