//
//  UVData.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import Foundation
struct UVData: Codable {
    let current: Current
    let daily:[Daily]
    struct Current: Codable {
        let uvi: Double
    }
    
    struct Daily: Codable {
        let pop: Double
    }
    
}
