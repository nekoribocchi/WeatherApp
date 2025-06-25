////
////  WeatherControlPanel.swift
////  WeatherApp
////
////  Created on 2025/06/25
////
//
//import SwiftUI
//
//struct WeatherControlPanel: View {
//    @Binding var currentWeather: WeatherType
//    
//    var body: some View {
//        HStack(spacing: 20) {
//            ForEach(WeatherType.allCases, id: \.self) { weather in
//                WeatherButton(
//                    weather: weather,
//                    isSelected: currentWeather == weather
//                ) {
//                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                        currentWeather = weather
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 16)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(.ultraThinMaterial)
//                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
//        )
//        .padding()
//    }
//}
//
//struct WeatherButton: View {
//    let weather: WeatherType
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 8) {
//                Image(systemName: weather.iconName)
//                    .font(.title2)
//                    .foregroundStyle(iconColor)
//                    .symbolEffect(.bounce, value: isSelected)
//                
//                Text(weather.displayName)
//                    .font(.caption.weight(.medium))
//                    .foregroundColor(textColor)
//            }
//            .frame(width: 70, height: 70)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(backgroundColor)
//                    .shadow(
//                        color: shadowColor,
//                        radius: isSelected ? 8 : 2,
//                        x: 0,
//                        y: isSelected ? 4 : 1
//                    )
//            )
//            .scaleEffect(isSelected ? 1.1 : 1.0)
//        }
//        .buttonStyle(PlainButtonStyle())
//        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
//    }
//    
//    private var iconColor: Color {
//        if isSelected {
//            switch weather {
//            case .rainy: return .blue
//            case .sunny: return .orange
//            case .cloudy: return .gray
//            }
//        } else {
//            return .primary.opacity(0.7)
//        }
//    }
//    
//    private var textColor: Color {
//        isSelected ? .primary : .secondary
//    }
//    
//    private var backgroundColor: Color {
//        isSelected ? Color.white.opacity(0.9) : Color.clear
//    }
//    
//    private var shadowColor: Color {
//        isSelected ? Color.black.opacity(0.3) : Color.clear
//    }
//}
