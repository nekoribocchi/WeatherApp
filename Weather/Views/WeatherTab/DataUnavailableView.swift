//
//  DataUnavailableView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//

import SwiftUI

// MARK: - データが利用できない時の共通表示ビュー
/// 重複していたエラー表示UIを統合し、再利用可能にしたビュー
struct DataUnavailableView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            // メインタイトル
            Text(title)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        DataUnavailableView(
            title: "気温データがありません",
        )
    }
    .padding()
}
