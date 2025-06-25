//
//  PopView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/25.
//

import SwiftUI

struct PopView: View {
    let pop: OneCallAPI30
    
    var body: some View {
        CapsuleView{
            Text("降水確率\((self.pop.daily.first?.pop ?? -1.0) * 100 )%")
        }
    }
}
