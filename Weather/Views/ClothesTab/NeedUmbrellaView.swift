//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct NeedUmbrellaView: View {
    let rain: OneCallAPI30
    
    var body: some View {
        if rain.daily.first!.pop > 0.5 {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
                VStack(spacing: 4) {
                    Image(systemName: "umbrella.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                    
                }
            }
        } else {
            EmptyView()
        }
    }
}
