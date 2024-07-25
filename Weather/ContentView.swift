import SwiftUI

struct ContentView: View {
    @StateObject private var weatherFetcher = WeatherFetcher()
    @State private var showWeatherDetails = false  // 天気詳細表示フラグ
    
    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // タイトル表示
                Text(weatherFetcher.selectedCityName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
                
                if showWeatherDetails {
                    // 天気詳細ビュー
                    VStack {
                        // 天気アイコン表示
                        Image(systemName: weatherFetcher.weatherIcon)
                            .font(.system(size: 100))
                            .foregroundColor(weatherFetcher.weatherIconColor.opacity(0.7))  // 色を設定
                            
                        // 天気情報表示
                        ScrollView {
                            Text(weatherFetcher.weatherInfo)
                                .padding()
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                        }
                        .padding()
                        
                        // 戻るボタン
                        Button(action: {
                            showWeatherDetails = false  // 詳細表示を解除
                            weatherFetcher.selectedCityName = "天気情報"  // タイトルをリセット
                        }) {
                            Text("戻る")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                                )
                            
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                
                        }
                        .padding()
                    }
                   
                } else {
                    // 都市リストスクロールビュー
                    ScrollView {
                        VStack {
                            ForEach(weatherFetcher.cities, id: \.2) { city in
                                Button(action: {
                                    weatherFetcher.fetchWeather(for: city.2, cityName: "\(city.0) \(city.1)")  // 天気情報を取得
                                    showWeatherDetails = true  // 詳細表示に切り替え
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            // 都道府県名表示
                                            Text(city.0)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            // 都市名表示
                                            Text(city.1)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        .padding()
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white.opacity(0.2))
                                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
                                    )
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            weatherFetcher.fetchCities()  // 都市情報を取得
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
