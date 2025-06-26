// DataUnavailableView.swift
// データが利用できない状態を表示するコンポーネント

import SwiftUI

struct DataUnavailableView: View {
    // MARK: - Properties
    let title: String
    let subtitle: String? // 修正: サブタイトルを追加（オプション）
    let iconName: String
    
    // MARK: - Initializers
    /// データ利用不可ビューのイニシャライザ
    /// - Parameters:
    ///   - title: メインタイトル
    ///   - subtitle: サブタイトル（オプション）
    ///   - iconName: 表示するSFSymbolsアイコン名
    init(
        title: String,
        subtitle: String? = nil,
        iconName: String = "exclamationmark.circle"
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            // アイコン表示
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            // メインタイトル
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            // サブタイトル（存在する場合のみ表示）
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.secondary.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        DataUnavailableView(
            title: "データがありません"
        )
        
        DataUnavailableView(
            title: "天気データがありません",
            subtitle: "下にスワイプして更新してください",
            iconName: "cloud.slash"
        )
    }
    .padding()
}
