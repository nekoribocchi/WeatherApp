//  WeatherView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/09.
//

import SwiftUI


// MARK: - Weather Display View
struct ClothesView: View {
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


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
/*
#Preview{
    ClothesView(weather: WeatherData(name: "Tokyo", main: WeatherData.Main(temp: 25.0, humidity: 60), weather: [WeatherData.Weather(main: "Clear", description: "晴れ", icon: "01d")]))
}

*/
