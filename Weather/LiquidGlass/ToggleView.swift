//
//  SwiftUIView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI


@available(iOS 26.0, *)
struct ToggleView: View {
    @State private var isExpanded: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        VStack{
            GlassEffectContainer(spacing:40) {
                Button("Toggle") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .buttonStyle(.glass)
                HStack(spacing: 40.0) {
                    Image(systemName: "umbrella.fill")
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectID("pencil", in: namespace)
                    
                    if isExpanded {
                        Image(systemName: "sunglasses.fill")
                            .frame(width: 80.0, height: 80.0)
                            .font(.system(size: 36))
                            .glassEffect()
                            .glassEffectID("eraser", in: namespace)
                    }
                }
            }
        }
    }
}


@available(iOS 26.0, *)
#Preview {
    ZStack{
        Image("4")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        ToggleView()
    }
    
}

