//  NeedUVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct NeedUVView: View {
    let uv: OneCallAPI30
    
    var body: some View {
        
            ZStack {
                if uv.current.uvi > 3 {
                    Circle()
                        .fill(.white).opacity(0.7)
                        .frame(width: 90, height: 90)
                        .shadow(radius: 5)
                }else{
                    Circle()
                        .fill(.gray).opacity(0.7)
                        .frame(width: 90, height: 90)
                        .shadow(radius: 5)
                    Image(systemName: "line.diagonal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                }
                VStack(spacing: 4) {
                    Image(systemName: "sunglasses.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                }
            }
            .accessibilityLabel("High UV index. Sunscreen recommended.")
    }
}


