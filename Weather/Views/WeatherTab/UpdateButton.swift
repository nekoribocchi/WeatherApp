//
//  UpdateButton.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//

import SwiftUI

struct UpdateButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack{
                Circle()
                    .fill(.white).opacity(0.93)
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 3, y: 3)
                
                Image(systemName: "arrow.clockwise")
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    UpdateButton(action: { print("Update tapped") })
}
