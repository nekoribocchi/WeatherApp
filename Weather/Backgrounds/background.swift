////
////  background.swift
////  Weather
////
////  Created by nekoribocchi on 2025/06/25.
////
//
//import SwiftUI
//
//struct WeatherBackgroundView: View {
//    @State private var currentWeather: WeatherType = .sunny
//    
//    var body: some View {
//        ZStack {
//            // 背景色
//            backgroundGradient
//                .ignoresSafeArea()
//            
//            // 天気アニメーション
//            weatherAnimation
//            
//            // コントロールパネル
//            VStack {
//                Spacer()
//                
//                HStack(spacing: 20) {
//                    weatherButton(.rainy, "雨", "cloud.rain.fill")
//                    weatherButton(.sunny, "快晴", "sun.max.fill")
//                    weatherButton(.cloudy, "曇り", "cloud.fill")
//                }
//                .padding()
//                .background(Color.black.opacity(0.3))
//                .cornerRadius(15)
//                .padding()
//            }
//        }
//        .animation(.easeInOut(duration: 1.0), value: currentWeather)
//    }
//    
//    // 背景グラデーション
//    private var backgroundGradient: some View {
//        LinearGradient(
//            gradient: Gradient(colors: backgroundColors),
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        )
//    }
//    
//    private var backgroundColors: [Color] {
//        switch currentWeather {
//        case .rainy:
//            return [Color.gray.opacity(0.8), Color.blue.opacity(0.6)]
//        case .sunny:
//            return [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
//        case .cloudy:
//            return [Color.gray.opacity(0.6), Color.white.opacity(0.8)]
//        }
//    }
//    
//    // 天気アニメーション
//    @ViewBuilder
//    private var weatherAnimation: some View {
//        switch currentWeather {
//        case .rainy:
//            RainAnimation()
//        case .sunny:
//            SunnyAnimation()
//        case .cloudy:
//            CloudyAnimation()
//        }
//    }
//    
//    // 天気切り替えボタン
//    private func weatherButton(_ weather: WeatherType, _ title: String, _ icon: String) -> some View {
//        Button(action: {
//            currentWeather = weather
//        }) {
//            VStack(spacing: 8) {
//                Image(systemName: icon)
//                    .font(.title2)
//                    .foregroundColor(currentWeather == weather ? .yellow : .white)
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(.white)
//            }
//            .padding()
//            .background(
//                currentWeather == weather ?
//                Color.white.opacity(0.3) : Color.clear
//            )
//            .cornerRadius(10)
//        }
//    }
//}
//
//// 天気タイプ
//enum WeatherType: CaseIterable {
//    case rainy, sunny, cloudy
//}
//
//// 雨のアニメーション
//struct RainAnimation: View {
//    @State private var raindrops: [Raindrop] = []
//    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    
//    var body: some View {
//        ZStack {
//            ForEach(raindrops, id: \.id) { drop in
//                Circle()
//                    .fill(Color.blue.opacity(0.6))
//                    .frame(width: drop.size, height: drop.size * 3)
//                    .position(x: drop.x, y: drop.y)
//                    .animation(.linear(duration: drop.speed), value: drop.y)
//            }
//        }
//        .onReceive(timer) { _ in
//            addRaindrop()
//            updateRaindrops()
//        }
//        .onAppear {
//            generateInitialRain()
//        }
//    }
//    
//    private func generateInitialRain() {
//        for _ in 0..<50 {
//            raindrops.append(Raindrop())
//        }
//    }
//    
//    private func addRaindrop() {
//        if raindrops.count < 100 {
//            raindrops.append(Raindrop())
//        }
//    }
//    
//    private func updateRaindrops() {
//        raindrops = raindrops.compactMap { drop in
//            var newDrop = drop
//            newDrop.y += 15
//            return newDrop.y < UIScreen.main.bounds.height + 50 ? newDrop : nil
//        }
//    }
//}
//
//// 雨粒構造体
//struct Raindrop {
//    let id = UUID()
//    let x: CGFloat
//    var y: CGFloat
//    let size: CGFloat
//    let speed: Double
//    
//    init() {
//        self.x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
//        self.y = CGFloat.random(in: -100...0)
//        self.size = CGFloat.random(in: 2...4)
//        self.speed = Double.random(in: 0.5...1.0)
//    }
//}
//
//// 快晴のアニメーション（光が差し込む演出）
//struct SunnyAnimation: View {
//    @State private var lightIntensity: Double = 0.7
//    @State private var rayRotation: Double = 0
//    @State private var particleOffset: CGFloat = 0
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // 中央の明るいエリア
//                RadialGradient(
//                    gradient: Gradient(colors: [
//                        Color.white.opacity(1.0),
//                        Color.yellow.opacity(0.4),
//                        Color.clear
//                    ]),
//                    center: .center,
//                    startRadius: 0,
//                    endRadius: 200
//                )
//                .scaleEffect(lightIntensity + 0.3)
//                
//                // 光の粒子エフェクト
//                ForEach(0..<20, id: \.self) { index in
//                    LightParticle(index: index, offset: particleOffset)
//                        .opacity(lightIntensity)
//                }
//            }
//        }
//        .onAppear {
//            // 光の強弱のアニメーション
//            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
//                lightIntensity = 1.0
//            }
//            // 光線の回転アニメーション
//            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
//                rayRotation = 360
//            }            // 粒子の動きアニメーション
//            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
//                particleOffset = 100
//            }
//        }
//    }
//}
//
//// 光線の形状
//struct RayOfLight: View {
//    let angle: Double
//    
//    var body: some View {
//        LinearGradient(
//            gradient: Gradient(colors: [
//                Color.white.opacity(0.8),
//                Color.yellow.opacity(0.6),
//                Color.clear
//            ]),
//            startPoint: .center,
//            endPoint: .leading
//        )
//        .frame(width: 400, height: 8)
//        .blur(radius: 4)
//        .rotationEffect(.degrees(angle))
//    }
//}
//
//// 光の粒子
//struct LightParticle: View {
//    let index: Int
//    let offset: CGFloat
//    @State private var position: CGPoint = CGPoint(x: 0, y: 0)
//    @State private var opacity: Double = 0
//    
//    var body: some View {
//        Circle()
//            .fill(Color.white)
//            .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
//            .blur(radius: 1)
//            .position(position)
//            .opacity(opacity)
//            .onAppear {
//                setupParticle()
//                animateParticle()
//            }
//    }
//    
//    private func setupParticle() {
//        let angle = Double(index) * (360.0 / 20.0) * .pi / 180
//        let radius = CGFloat.random(in: 50...150)
//        
//        position = CGPoint(
//            x: UIScreen.main.bounds.width / 2 + CGFloat(cos(angle)) * radius,
//            y: UIScreen.main.bounds.height / 2 + CGFloat(sin(angle)) * radius
//        )
//    }
//    
//    private func animateParticle() {
//        withAnimation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true)) {
//            opacity = Double.random(in: 0.3...0.8)
//        }
//        
//        withAnimation(.linear(duration: Double.random(in: 3...6)).repeatForever(autoreverses: false)) {
//            let angle = Double(index) * (360.0 / 20.0) * .pi / 180
//            let newRadius = CGFloat.random(in: 80...200)
//            
//            position = CGPoint(
//                x: UIScreen.main.bounds.width / 2 + CGFloat(cos(angle)) * newRadius,
//                y: UIScreen.main.bounds.height / 2 + CGFloat(sin(angle)) * newRadius
//            )
//        }
//    }
//}
//
//// 曇りのアニメーション
//struct CloudyAnimation: View {
//    @State private var clouds: [Cloud] = []
//    
//    var body: some View {
//        ZStack {
//            ForEach(clouds, id: \.id) { cloud in
//                CloudShape()
//                    .fill(Color.white.opacity(cloud.opacity))
//                    .frame(width: cloud.width, height: cloud.height)
//                    .position(x: cloud.x, y: cloud.y)
//                    .animation(.linear(duration: cloud.speed).repeatForever(autoreverses: false), value: cloud.x)
//            }
//        }
//        .onAppear {
//            generateClouds()
//            animateClouds()
//        }
//    }
//    
//    private func generateClouds() {
//        for i in 0..<6 {
//            clouds.append(Cloud(index: i))
//        }
//    }
//    
//    private func animateClouds() {
//        for i in clouds.indices {
//            withAnimation(.linear(duration: clouds[i].speed).repeatForever(autoreverses: false)) {
//                clouds[i].x = UIScreen.main.bounds.width + 100
//            }
//        }
//    }
//}
//
//// 雲の構造体
//struct Cloud {
//    let id = UUID()
//    var x: CGFloat
//    let y: CGFloat
//    let width: CGFloat
//    let height: CGFloat
//    let opacity: Double
//    let speed: Double
//    
//    init(index: Int) {
//        self.x = CGFloat.random(in: -200...(-50))
//        self.y = CGFloat.random(in: 50...300)
//        self.width = CGFloat.random(in: 80...150)
//        self.height = CGFloat.random(in: 40...80)
//        self.opacity = Double.random(in: 0.5...0.9)
//        self.speed = Double.random(in: 15...25)
//    }
//}
//
//// 雲の形状
//struct CloudShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let width = rect.width
//        let height = rect.height
//        
//        // 雲の基本形状を描画
//        path.addEllipse(in: CGRect(x: 0, y: height * 0.3, width: width * 0.4, height: height * 0.7))
//        path.addEllipse(in: CGRect(x: width * 0.2, y: height * 0.1, width: width * 0.5, height: height * 0.8))
//        path.addEllipse(in: CGRect(x: width * 0.4, y: height * 0.2, width: width * 0.4, height: height * 0.6))
//        path.addEllipse(in: CGRect(x: width * 0.6, y: height * 0.3, width: width * 0.4, height: height * 0.7))
//        
//        return path
//    }
//}
//
//// メインビュー
//struct ContentView: View {
//    var body: some View {
//        WeatherBackgroundView()
//    }
//}
//
//#Preview {
//    ContentView()
//}
