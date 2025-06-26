//
//  ErrorView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/26.
//
// エラー状態の表示コンポーネント - エラーメッセージとリトライ機能を提供

import SwiftUI

struct ErrorView: View {
    // MARK: - Properties
    let errorMessage: String
    let onRetry: () -> Void // 修正: クロージャーを使用してリトライ処理を委譲
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // エラーアイコン
            errorIcon
            
            // エラーメッセージ
            errorMessageText
            
            // リトライボタン
            retryButton
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.red.opacity(0.3), lineWidth: 1)
                )
        )
        .padding()
    }
    
    // MARK: - View Components
    
    /// エラーアイコンの表示
    private var errorIcon: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 50))
            .foregroundColor(.red)
            .symbolRenderingMode(.multicolor)
    }
    
    /// エラーメッセージテキストの表示
    private var errorMessageText: some View {
        VStack(spacing: 8) {
            Text("エラーが発生しました")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true) // 修正: テキストの表示を改善
        }
    }
    
    /// リトライボタンの表示
    private var retryButton: some View {
        Button(action: onRetry) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("再試行")
            }
            .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

// MARK: - Preview
#Preview {
    ErrorView(
        errorMessage: "ネットワーク接続に失敗しました。インターネット接続を確認してください。",
        onRetry: {
            print("リトライが実行されました")
        }
    )
    .previewLayout(.sizeThatFits)
}
