//
//  RealisticSunnyView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct RealisticSunnyView: View {
    @State private var lightRays: [LightRayData] = []
    @State private var atmosphericParticles: [AtmosphericParticle] = []
    @State private var sunPosition: CGPoint = CGPoint(x: 300, y: 80)
    @State private var lightIntensity: Double = 0.8
    @State private var heatShimmer: Double = 0
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 大気散乱効果
                AtmosphericScatteringView(sunPosition: sunPosition)
                
                // 太陽のコロナ効果
                SunCoronaView(position: sunPosition, intensity: lightIntensity)
                
                // 光線（雲の隙間から）
                ForEach(lightRays) { ray in
                    LightRayView(data: ray, intensity: lightIntensity)
                }
                
                // 大気中の粒子
                ForEach(atmosphericParticles) { particle in
                    AtmosphericParticleView(particle: particle)
                }
                
                // 陽炎効果
                HeatShimmerView(intensity: heatShimmer)
                
                // レンズフレア効果
                LensFlareView(sunPosition: sunPosition, intensity: lightIntensity)
            }
        }
        .onReceive(timer) { _ in
            updateAtmosphericParticles()
        }
        .onAppear {
            initializeSunnyEffect()
            startLightAnimation()
        }
    }
    
    private func initializeSunnyEffect() {
        // 光線の初期化
        lightRays = (0..<12).map { index in
            LightRayData(
                from: sunPosition,
                angle: Double(index * 30 - 150) + Double.random(in: -10...10),
                length: 400
            )
        }
        
        // 大気粒子の初期化
        atmosphericParticles = (0..<50).map { _ in AtmosphericParticle() }
    }
    
    private func updateAtmosphericParticles() {
        // 粒子の更新
        for i in atmosphericParticles.indices {
            atmosphericParticles[i].update(deltaTime: 0.05)
        }
        
        // 死んだ粒子を新しいものに置き換え
        atmosphericParticles = atmosphericParticles.map { particle in
            particle.isDead ? AtmosphericParticle() : particle
        }
    }
    
    private func startLightAnimation() {
        // 光の強弱アニメーション
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            lightIntensity = 1.2
        }
        
        // 陽炎効果
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            heatShimmer = 1.0
        }
    }
}

struct AtmosphericScatteringView: View {
    let sunPosition: CGPoint
    
    var body: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: Color.white.opacity(0.6), location: 0),
                .init(color: Color.yellow.opacity(0.3), location: 0.3),
                .init(color: Color.orange.opacity(0.15), location: 0.6),
                .init(color: Color.clear, location: 1.0)
            ]),
            center: UnitPoint(
                x: sunPosition.x / UIScreen.main.bounds.width,
                y: sunPosition.y / UIScreen.main.bounds.height
            ),
            startRadius: 0,
            endRadius: 300
        )
        .blendMode(.screen)
    }
}

struct SunCoronaView: View {
    let position: CGPoint
    let intensity: Double
    @State private var coronaScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // 内側のコロナ
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.9),
                            Color.yellow.opacity(0.7),
                            Color.orange.opacity(0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(coronaScale)
                .blur(radius: 8)
            
            // 外側のコロナ
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.4),
                            Color.yellow.opacity(0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(coronaScale * 0.8)
                .blur(radius: 15)
        }
        .position(position)
        .opacity(intensity)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                coronaScale = 1.3
            }
        }
    }
}

struct LightRayView: View {
    let data: LightRayData
    let intensity: Double
    
    var body: some View {
        Path { path in
            path.move(to: data.startPoint)
            path.addLine(to: data.endPoint)
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.8),
                    Color.yellow.opacity(0.6),
                    Color.orange.opacity(0.3),
                    Color.clear
                ]),
                startPoint: .init(x: 0, y: 0),
                endPoint: .init(x: 1, y: 1)
            ),
            style: StrokeStyle(lineWidth: data.width, lineCap: .round)
        )
        .blur(radius: 12)
        .opacity(data.intensity * intensity)
        .blendMode(.screen)
    }
}

struct AtmosphericParticleView: View {
    let particle: AtmosphericParticle
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(particle.currentOpacity))
            .frame(width: particle.size, height: particle.size)
            .position(particle.position)
            .blur(radius: particle.size / 2)
    }
}

struct HeatShimmerView: View {
    let intensity: Double
    @State private var shimmerOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 100)
                .offset(x: shimmerOffset)
                .blur(radius: 8)
                .opacity(intensity * 0.6)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                shimmerOffset = 20
            }
        }
    }
}

struct LensFlareView: View {
    let sunPosition: CGPoint
    let intensity: Double
    
    var body: some View {
        ZStack {
            // メインフレア
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.yellow.opacity(0.3),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 60, height: 60)
                .position(
                    x: sunPosition.x - 100,
                    y: sunPosition.y + 150
                )
            
            // サブフレア
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.4),
                            Color.red.opacity(0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 20
                    )
                )
                .frame(width: 40, height: 40)
                .position(
                    x: sunPosition.x - 200,
                    y: sunPosition.y + 250
                )
        }
        .opacity(intensity * 0.7)
        .blendMode(.screen)
    }
}

#Preview{
    RealisticSunnyView()
        
}
