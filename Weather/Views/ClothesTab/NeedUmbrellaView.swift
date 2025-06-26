//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct NeedUmbrellaView: View {
    let rain: OneCallAPI30
    
    var body: some View {
        
        ZStack {
            if rain.daily.first!.pop > 0.5 {
                Circle()
                    .fill(.white).opacity(0.7)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
            } else {
                Circle()
                    .fill(.gray).opacity(0.7)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
            }
            VStack(spacing: 4) {
                Image(systemName: "umbrella.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
        }
    }
}
