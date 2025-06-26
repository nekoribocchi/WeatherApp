//
//  OneCallAPI30.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import Foundation
struct OneCallAPI30: Codable {
    let current: Current
    let daily:[Daily]
    struct Current: Codable {
        let uvi: Double
    }
    
    struct Daily: Codable {
        let weather: Weather
        let pop: Double
        
        struct Weather: Codable {
            let main: String
            let description: String
            let icon: String
        }
    }
    
}
