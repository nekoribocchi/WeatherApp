//
//  UVView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct UVView: View {
    let uv: OneCallAPI30
    
    var body: some View {
        CapsuleView {
            Text("UV: \(uv.current.uvi)")
        }
    }
}
