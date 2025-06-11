//
//  GlassEffectContainerView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

@available(iOS 26.0, *)
struct GlassEffectContainerView2: View {
    let symbolSet: [String] = ["cloud.bolt.rain.fill", "sun.rain.fill", "moon.stars.fill", "moon.fill"]
    @Namespace private var namespace
    
    var body: some View {
        GlassEffectContainer(spacing: 20.0) {
            HStack(spacing: 20.0) {
                ForEach(symbolSet.indices, id: \.self) { item in
                    Image(systemName: symbolSet[item])
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
                }
            }
        }
    }
}

@available(iOS 26.0, *)
#Preview {
    ZStack{
        Image("4")
        GlassEffectContainerView2()
    }
    
}
