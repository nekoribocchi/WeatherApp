//
//  LoadingView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.

// ローディング状態の表示コンポーネント - データ取得中の視覚的フィードバック

import SwiftUI

struct LoadingView: View {
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // 修正: より視覚的に分かりやすいローディング表示
            ProgressView()
                .scaleEffect(1.5)
                .tint(.blue)
            
            Text("天気データを読み込み中...")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("しばらくお待ちください")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            // 修正: 背景に軽いブラー効果を追加（視覚的改善）
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
        .padding()
    }
}

// MARK: - Preview
#Preview {
    LoadingView()
        .previewLayout(.sizeThatFits)
}
