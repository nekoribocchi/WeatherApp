//
//  GlassEffectContainer.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

@available(iOS 26.0, *)
struct GlassEffectContainerView: View {
    var body: some View {
        GlassEffectContainer(spacing: 70.0) {
            HStack(spacing: 20.0) {
                Image(systemName: "scribble.variable")
                    .frame(width: 80.0, height: 80.0)
                    .font(.system(size: 36))
                    .glassEffect()
                
                Image(systemName: "eraser.fill")
                    .frame(width: 80.0, height: 80.0)
                    .font(.system(size: 36))
                    .glassEffect()
            }
        }
    }
}


@available(iOS 26.0, *)
#Preview {
    ZStack{
        Image("4")
        GlassEffectContainerView()
    }
}
