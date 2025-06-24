//
//  UVData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import Foundation
struct UVData: Codable {
    let current: [Current]
    
    struct Current: Codable {
        let uvi: Double
    }
    
    
}
