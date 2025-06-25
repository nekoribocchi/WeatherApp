//
//  RealisticCloudyView.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

struct RealisticCloudyView: View {
    @State private var mistLayers: [MistLayer] = []
    @State private var atmosphericHaze: [HazeParticle] = []
    @State private var fogDensity: Double = 0.3
    @State private var windFlow: CGFloat = 0
    
    private let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // 大気のぼかし効果
            AtmosphericBlur()
            
            // 複数の霧の層
            ForEach(mistLayers, id: \.id) { mist in
                MistLayerView(layer: mist, windFlow: windFlow)
            }
            
            // 浮遊する霧の粒子
            ForEach(atmosphericHaze, id: \.id) { haze in
                HazeParticleView(particle: haze)
            }
            
            // 全体的な霧のオーバーレイ
            FogOverlay(density: fogDensity)
            
            // 遠景のぼかし効果
            DistantHaze()
        }
        .onReceive(timer) { _ in
            updateMistEffect()
        }
        .onAppear {
            initializeMistEffect()
            startAtmosphericAnimation()
        }
    }
    
    private func initializeMistEffect() {
        // 霧の層を初期化（複数の深度で）
        mistLayers = (0..<8).map { index in
            MistLayer(depth: index)
        }
        
        // 大気中の霧粒子を初期化
        atmosphericHaze = (0..<30).map { _ in
            HazeParticle()
        }
    }
    
    private func updateMistEffect() {
        // 霧の層の更新
        for i in mistLayers.indices {
            mistLayers[i].update()
        }
        
        // 霧粒子の更新
        for i in atmosphericHaze.indices {
            atmosphericHaze[i].update()
            
            // 古い粒子を新しいものに置き換え
            if atmosphericHaze[i].shouldReset {
                atmosphericHaze[i] = HazeParticle()
            }
        }
    }
    
    private func startAtmosphericAnimation() {
        // 風の流れアニメーション
        withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
            windFlow = 50
        }
        
        // 霧の濃度変化
        withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
            fogDensity = 0.6
        }
    }
}

// 大気のぼかし効果
struct AtmosphericBlur: View {
    @State private var blurIntensity: Double = 8
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.1),
                        Color.gray.opacity(0.05),
                        Color.white.opacity(0.08),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .blur(radius: blurIntensity)
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    blurIntensity = 12
                }
            }
    }
}

// 霧の層データ
struct MistLayer: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let scale: CGFloat
    let opacity: Double
    let depth: Int
    var rotation: Double
    
    init(depth: Int) {
        self.depth = depth
        self.position = CGPoint(
            x: CGFloat.random(in: -200...UIScreen.main.bounds.width + 200),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        self.velocity = CGPoint(
            x: CGFloat.random(in: 0.1...0.5) * (1.0 + CGFloat(depth) * 0.1),
            y: CGFloat.random(in: -0.2...0.2)
        )
        self.scale = CGFloat.random(in: 1.5...3.0) * (1.0 + CGFloat(depth) * 0.2)
        self.opacity = Double.random(in: 0.05...0.15) * (1.0 - Double(depth) * 0.02)
        self.rotation = Double.random(in: 0...360)
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
        rotation += 0.1
        
        // 画面外に出たら反対側から再登場
        if position.x > UIScreen.main.bounds.width + 300 {
            position.x = -300
            position.y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        }
    }
}

// 霧の層ビュー
struct MistLayerView: View {
    let layer: MistLayer
    let windFlow: CGFloat
    
    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(layer.opacity),
                        Color.gray.opacity(layer.opacity * 0.7),
                        Color.white.opacity(layer.opacity * 0.3),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 150
                )
            )
            .frame(width: 300 * layer.scale, height: 200 * layer.scale)
            .position(
                x: layer.position.x + windFlow * CGFloat(layer.depth + 1) * 0.3,
                y: layer.position.y
            )
            .rotationEffect(.degrees(layer.rotation))
            .blur(radius: CGFloat(8 + layer.depth * 2))
    }
}

// 大気中の霧粒子データ
struct HazeParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let size: CGFloat
    var opacity: Double
    var life: Double
    let maxLife: Double
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        self.velocity = CGPoint(
            x: CGFloat.random(in: -0.3...0.3),
            y: CGFloat.random(in: -0.2...0.2)
        )
        self.size = CGFloat.random(in: 20...60)
        self.opacity = Double.random(in: 0.03...0.08)
        self.maxLife = Double.random(in: 15...30)
        self.life = maxLife
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
        life -= 0.08
        
        // 境界チェック
        if position.x < -size { position.x = UIScreen.main.bounds.width + size }
        if position.x > UIScreen.main.bounds.width + size { position.x = -size }
        if position.y < -size { position.y = UIScreen.main.bounds.height + size }
        if position.y > UIScreen.main.bounds.height + size { position.y = -size }
    }
    
    var shouldReset: Bool {
        life <= 0
    }
    
    var currentOpacity: Double {
        opacity * (life / maxLife)
    }
}

// 霧粒子ビュー
struct HazeParticleView: View {
    let particle: HazeParticle
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(particle.currentOpacity),
                        Color.gray.opacity(particle.currentOpacity * 0.6),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: particle.size / 2
                )
            )
            .frame(width: particle.size, height: particle.size)
            .position(particle.position)
            .blur(radius: particle.size / 4)
    }
}

// 全体的な霧のオーバーレイ
struct FogOverlay: View {
    let density: Double
    @State private var overlayShift: CGFloat = 0
    
    var body: some View {
        ZStack {
            // メインの霧
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(density * 0.2),
                            Color.gray.opacity(density * 0.1),
                            Color.white.opacity(density * 0.15),
                            Color.gray.opacity(density * 0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .offset(x: overlayShift)
            
            // 動く霧の模様
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(density * 0.1),
                            Color.clear,
                            Color.white.opacity(density * 0.08),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: -overlayShift * 0.5)
        }
        .blur(radius: 15)
        .onAppear {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                overlayShift = 100
            }
        }
    }
}

// 遠景のぼかし効果
struct DistantHaze: View {
    @State private var hazeIntensity: Double = 0.4
    
    var body: some View {
        VStack {
            // 上部の霞
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(hazeIntensity * 0.3),
                            Color.gray.opacity(hazeIntensity * 0.2),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: UIScreen.main.bounds.height * 0.4)
            
            Spacer()
            
            // 下部の霞
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(hazeIntensity * 0.2),
                            Color.gray.opacity(hazeIntensity * 0.15)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: UIScreen.main.bounds.height * 0.3)
        }
        .blur(radius: 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 14).repeatForever(autoreverses: true)) {
                hazeIntensity = 0.7
            }
        }
    }
}


#Preview {
    RealisticCloudyView()
}
