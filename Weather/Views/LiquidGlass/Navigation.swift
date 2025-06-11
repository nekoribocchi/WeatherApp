//  Navigation.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/11.
//

import SwiftUI

@available(iOS 26.0, *)
struct Navigation: View {
  
    var body: some View {
        NavigationStack {
            NavigationLink("To RequidGrass", destination: RequidGrassView())
                .navigationTitle("Home")
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        Navigation()
    } else {
        // Fallback on earlier versions
    }
}
