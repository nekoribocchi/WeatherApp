//
//  TextView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

@available(iOS 26.0, *)
struct TextView: View {
    
    var body: some View {
        VStack{
            Text("Tokyo")
                .font(.title)
                .padding()
                .glassEffect(.regular.interactive())
            
            Text("Tokyo")
                .font(.title)
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16.0))
        }
    }
}
@available(iOS 26.0, *)
#Preview {
    ZStack{
        Image("4")
        TextView()
    }
}

