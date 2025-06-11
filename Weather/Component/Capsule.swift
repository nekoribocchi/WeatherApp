//
//  Capsule.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

struct Capsule: View {
    var body: some View {
        if #available(iOS 26.0, *) {
            Text("Tokyo")
                .font(.default)
                .padding()
                .glassEffect()
        } else{
            Text("Tokyo")
                .font(.title)
                .padding()
        }
    }
}

@available(iOS 26.0, *)
#Preview {
    Capsule()
}

@available(iOS 18.0, *)
#Preview {
    Capsule()
}
