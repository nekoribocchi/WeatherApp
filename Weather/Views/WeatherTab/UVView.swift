//
//  UVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI
import GlassmorphismUI

struct UVView: View {
    let uv: OneCallAPI30
    
    var body: some View {
        RoundRectangleView(heightRatio: 0.8,widthRatio: 0.8) {
            VStack{
                Text("UV")
                    .font(.system(size: 24, weight: .bold))
                        
             Text("\(Int(uv.current.uvi))")
                    .font(.system(size: 24, weight: .bold))
                    
            }
            
        }
    }
}

#Preview{
    VStack{
        UVView(uv: OneCallAPI30(current: OneCallAPI30.Current(uvi: 3.7), daily: [OneCallAPI30.Daily(pop: 0.7)]))
        
        UVView(uv: OneCallAPI30(current: OneCallAPI30.Current(uvi: 3.7), daily: [OneCallAPI30.Daily(pop: 0.7)]))
    }
    
}

