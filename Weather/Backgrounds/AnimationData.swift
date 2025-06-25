//
//  WeatherTypes.swift
//  WeatherApp
//
//  Created on 2025/06/25
//

import SwiftUI

// 雨粒データモデル
struct RaindropData: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let size: CGFloat
    let opacity: Double
    let angle: Double
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: -50...UIScreen.main.bounds.width + 50),
            y: CGFloat.random(in: -200...0)
        )
        self.velocity = CGPoint(
            x: CGFloat.random(in: -2...2),
            y: CGFloat.random(in: 8...15)
        )
        self.size = CGFloat.random(in: 1...3)
        self.opacity = Double.random(in: 0.4...0.8)
        self.angle = Double.random(in: -15...15)
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
    }
    
    var isOffScreen: Bool {
        position.y > UIScreen.main.bounds.height + 100
    }
}

// 雲データモデル
struct CloudData: Identifiable {
    let id = UUID()
    var position: CGPoint
    let velocity: CGFloat
    let scale: CGFloat
    let opacity: Double
    let layers: Int
    
    init(startX: CGFloat = -200, y: CGFloat) {
        self.position = CGPoint(x: startX, y: y)
        self.velocity = CGFloat.random(in: 0.3...0.8)
        self.scale = CGFloat.random(in: 0.8...1.5)
        self.opacity = Double.random(in: 0.6...0.9)
        self.layers = Int.random(in: 3...6)
    }
    
    mutating func update() {
        position.x += velocity
    }
    
    var isOffScreen: Bool {
        position.x > UIScreen.main.bounds.width + 200
    }
}

// 光線データモデル
struct LightRayData: Identifiable {
    let id = UUID()
    let startPoint: CGPoint
    let endPoint: CGPoint
    let width: CGFloat
    let intensity: Double
    let angle: Double
    
    init(from: CGPoint, angle: Double, length: CGFloat) {
        self.startPoint = from
        self.angle = angle
        self.width = CGFloat.random(in: 20...40)
        self.intensity = Double.random(in: 0.3...0.7)
        
        let radians = angle * .pi / 180
        self.endPoint = CGPoint(
            x: from.x + CGFloat(cos(Double(radians))) * length,
            y: from.y + CGFloat(sin(Double(radians))) * length
        )
    }
}

// 大気粒子データモデル
struct AtmosphericParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let size: CGFloat
    let opacity: Double
    var life: Double
    let maxLife: Double
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        self.velocity = CGPoint(
            x: CGFloat.random(in: -0.5...0.5),
            y: CGFloat.random(in: -0.3...0.3)
        )
        self.size = CGFloat.random(in: 1...4)
        self.opacity = Double.random(in: 0.1...0.4)
        self.maxLife = Double.random(in: 5...15)
        self.life = maxLife
    }
    
    mutating func update(deltaTime: Double) {
        position.x += velocity.x
        position.y += velocity.y
        life -= deltaTime
        
        // 画面外に出たら反対側から再登場
        if position.x < 0 { position.x = UIScreen.main.bounds.width }
        if position.x > UIScreen.main.bounds.width { position.x = 0 }
        if position.y < 0 { position.y = UIScreen.main.bounds.height }
        if position.y > UIScreen.main.bounds.height { position.y = 0 }
    }
    
    var isDead: Bool {
        life <= 0
    }
    
    var currentOpacity: Double {
        opacity * (life / maxLife)
    }
}
