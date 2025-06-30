//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI
import GlassmorphismUI
struct NeedUmbrellaView: View {
    let rain: OneCallAPI30
    
    var body: some View {
        
        ZStack {
            if rain.daily.first!.pop > 0.5 {
                WhiteCircle{
                    Image(systemName: "umbrella.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            } else {
                WhiteCircle(backgroundColor: .gray){
                    Image(systemName: "umbrella.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
                Image(systemName: "line.diagonal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
        }
    }
}
#Preview {
    VStack {
        Text("Low Pop")
        NeedUmbrellaView(rain: OneCallAPI30(
            current: .init(uvi: 5, weather: [OneCallAPI30.Weather(main: "Clear", description: "clear sky", icon: "01d")]),
            daily: [OneCallAPI30.Daily(pop: 0.0, weather: [OneCallAPI30.Weather(main: "Clear", description: "clear sky", icon: "01d")])]
        ))
        Text("High Pop")
        NeedUmbrellaView(rain: OneCallAPI30(
            current: .init(uvi: 1, weather: [OneCallAPI30.Weather(main: "Clouds", description: "overcast clouds", icon: "04d")]),
            daily: [OneCallAPI30.Daily(pop: 0.6, weather: [OneCallAPI30.Weather(main: "Rain", description: "light rain", icon: "10d")])]
        ))
    }
}
