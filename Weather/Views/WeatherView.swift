import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer().frame(height: 24)
                // City Name
                Text("Tokyo")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                    )
                // Big Sun Icon
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 140, height: 140)
                    .shadow(radius: 4)
                
                // Hourly Forecast stub
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .overlay(
                            VStack(spacing: 8) {
                                HStack(spacing: 16) {
                                    ForEach(10..<17, id: \ .self) { hour in
                                        VStack(spacing: 2) {
                                            Text("\(hour)")
                                                .font(.caption2)
                                                .foregroundColor(.primary)
                                            Image(systemName: "cloud.sun.fill")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                            Text("21℃")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                HStack {
                                    Text("19℃")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Text("24℃")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.vertical, 16)
                        )
                        .frame(height: 100)
                        .padding(.horizontal, 24)
                }
                // UV & Rain cards
                HStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 130)
                        .overlay(
                            VStack(spacing: 8) {
                                Text("UV")
                                    .font(.headline)
                                Image(systemName: "gauge.open.with.lines")
                                    .font(.largeTitle)
                                    .foregroundColor(.green)
                                Text("Strong")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        )
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 130)
                        .overlay(
                            VStack(spacing: 8) {
                                Text("Rain")
                                    .font(.headline)
                                Text("40\n%")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                                Text("")
                            }
                        )
                }
                .padding(.horizontal, 24)
                Spacer()
    
            }
        }
    }
}

#Preview {
    VStack{
        WeatherView()
    }
   
}
