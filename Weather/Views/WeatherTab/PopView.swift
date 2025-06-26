//
//  PopView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI
import GlassmorphismUI

struct PopView: View {
    let pop: OneCallAPI30
    
    var body: some View {
        RoundRectangleView(heightRatio: 0.8,widthRatio: 0.9) {
            VStack{
                Text("Rain")
                    .font(.system(size: 24, weight: .bold))
                
                Text("\(Int(floor((self.pop.daily.first?.pop ?? -1.0) * 100)))%")
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
}
//#Preview("PopView") {
//    PopView(pop: OneCallAPI30(current: OneCallAPI30.Current(uvi: 0.0), daily: [OneCallAPI30.Daily(pop: 0.7)]))
//}
