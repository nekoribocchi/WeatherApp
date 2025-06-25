//
//  RealisticRainView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct RealisticRainView: View {
    @State private var raindrops: [RaindropData] = []
    @State private var splashes: [SplashEffect] = []
    @State private var windEffect: CGFloat = 0
    @State private var rainIntensity: Double = 1.0
    
    private let maxRaindrops = 200
    private let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // 60fps
    
    var body: some View {
        ZStack {
            // 雨の霧効果
            RainMistEffect()
                .opacity(0.6)
            
            // 雨粒
            ForEach(raindrops) { drop in
                RaindropView(data: drop, windEffect: windEffect)
            }
            
            // 地面の水たまり反射
            PuddleReflectionView()
                .opacity(0.3)
        }
        .onReceive(timer) { _ in
            updateRainSimulation()
        }
        .onAppear {
            initializeRain()
            startWindAnimation()
            startIntensityVariation()
        }
    }
    
    private func initializeRain() {
        raindrops = (0..<maxRaindrops).map { _ in RaindropData() }
    }
    
    private func updateRainSimulation() {
        // 雨粒の更新
        for i in raindrops.indices {
            raindrops[i].update()
            
            // 地面に到達したら水しぶきを生成
            if raindrops[i].position.y > UIScreen.main.bounds.height - 50 {
                if Double.random(in: 0...1) < 0.3 {
                    splashes.append(SplashEffect(at: raindrops[i].position))
                }
                raindrops[i] = RaindropData()
            }
        }
        
        // 画面外の雨粒を新しいものに置き換え
        raindrops = raindrops.map { drop in
            drop.isOffScreen ? RaindropData() : drop
        }
        
        // 古い水しぶきを削除
        splashes = splashes.filter { !$0.isFinished }
        
        // 水しぶきの更新
        for i in splashes.indices {
            splashes[i].update()
        }
    }
    
    private func startWindAnimation() {
        withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
            windEffect = 3
        }
    }
    
    private func startIntensityVariation() {
        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
            rainIntensity = 1.5
        }
    }
}

struct RaindropView: View {
    let data: RaindropData
    let windEffect: CGFloat
    
    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.2),
                        Color.black.opacity(0.2),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: data.size, height: data.size * 8)
            .position(
                x: data.position.x + windEffect,
                y: data.position.y
            )
            .rotationEffect(.degrees(data.angle + Double(windEffect * 2)))
            .opacity(data.opacity)
            .blur(radius: data.size > 2 ? 0.5 : 0)
    }
}

struct SplashEffect: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat = 0.1
    var opacity: Double = 1.0
    var life: Double = 1.0
    
    init(at position: CGPoint) {
        self.position = position
    }
    
    mutating func update() {
        scale += 0.05
        opacity -= 0.05
        life -= 0.05
    }
    
    var isFinished: Bool {
        life <= 0
    }
}

struct RainMistEffect: View {
    @State private var mistOffset: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.white.opacity(0.1), location: 0),
                .init(color: Color.gray.opacity(0.05), location: 0.3),
                .init(color: Color.clear, location: 0.7),
                .init(color: Color.white.opacity(0.03), location: 1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .offset(x: mistOffset)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                mistOffset = 100
            }
        }
    }
}

struct PuddleReflectionView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.1),
                            Color.blue.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 50)
                .blur(radius: 2)
        }
    }
}


#Preview {
    RealisticRainView()
}
