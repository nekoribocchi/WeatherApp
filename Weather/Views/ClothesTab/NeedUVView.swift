//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI
import GlassmorphismUI

struct NeedUVView: View {
    let uv: OneCallAPI30
    
    var body: some View {
        
            ZStack {
                if uv.current.uvi > 3 {
                    WhiteCircle{
                        Image(systemName: "sunglasses.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }else{
                    WhiteCircle(backgroundColor: .gray){
                        Image(systemName: "sunglasses.fill")
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
            .accessibilityLabel(uv.current.uvi > 3 ? "High UV index. Sunscreen recommended." : "Low UV index. Sunscreen not essential.")
    }
}

#Preview {
    VStack {
        Text("High UV Index")
        NeedUVView(uv: OneCallAPI30(
            current: .init(uvi: 5, weather: [OneCallAPI30.Weather(main: "Clear", description: "clear sky", icon: "01d")]),
            daily: [OneCallAPI30.Daily(pop: 0.0, weather: [OneCallAPI30.Weather(main: "Clear", description: "clear sky", icon: "01d")])]
        ))
        Text("Low UV Index")
        NeedUVView(uv: OneCallAPI30(
            current: .init(uvi: 1, weather: [OneCallAPI30.Weather(main: "Clouds", description: "overcast clouds", icon: "04d")]),
            daily: [OneCallAPI30.Daily(pop: 0.2, weather: [OneCallAPI30.Weather(main: "Rain", description: "light rain", icon: "10d")])]
        ))
    }
}
