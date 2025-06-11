//  LiquidGlassView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

@available(iOS 26.0, *)
struct LiquidGlassView: View {
    var body: some View {
        NavigationStack{
            NavigationLink(destination: LiquidGlassView2()) {
                ZStack{
                    Image("4")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    Text("Tokyo")
                        .font(.title)
                        .padding()
                        .glassEffect(.regular.interactive())
                }
            }
        }
    }
}

@available(iOS 26.0, *)
struct LiquidGlassView2 : View {
    var body: some View {
        Text("Tokyo")
            .font(.title)
            .padding()
            .glassEffect(.regular.interactive())
    }
}

@available(iOS 26.0, *)
#Preview {
    LiquidGlassView()
}
