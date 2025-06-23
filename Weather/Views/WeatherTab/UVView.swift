//
//  UVIndexView.swift
//  Weather
//
//  Created by nekoribocchi on 2025/06/23.
//

import SwiftUI

// MARK: - UV Index View

/// UV指数を表示するSwiftUIビュー
/// - UVIndexManagerを使用してデータを取得・表示
/// - リアルタイムでローディング状態とエラーを管理
@available(iOS 16.0, *)
struct UVIndexView: View {
    
    // MARK: - Properties
    
    @StateObject private var uvManager = UVIndexManager()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 現在のUV指数カード
                    currentUVIndexCard
                    
                    // 今日のUV指数予報カード
                    todayForecastCard
                    
                    // リフレッシュボタン
                    refreshButton
                }
                .padding()
            }
            .navigationTitle("UV指数")
            .onAppear {
                // ビューが表示されたときにデータを取得
                uvManager.loadAllUVData()
            }
            .alert("エラー", isPresented: .constant(!uvManager.errorMessage.isEmpty)) {
                Button("OK") {
                    uvManager.clearError()
                }
            } message: {
                Text(uvManager.errorMessage)
            }
        }
    }
    
    // MARK: - Private Views
    
    /// 現在のUV指数表示カード
    private var currentUVIndexCard: some View {
        VStack(spacing: 16) {
            Text("現在のUV指数")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if uvManager.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let uvData = uvManager.currentUVIndex {
                VStack(spacing: 12) {
                    // UV指数の値
                    Text("\(uvData.value)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(Color(uvManager.currentUVCategoryColor))
                    
                    // カテゴリ
                    Text(uvData.category.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // 推奨事項
                    Text(uvData.recommendation)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // 更新時刻
                    Text("更新: \(uvData.date, formatter: timeFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("データが取得できませんでした")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    /// 今日のUV指数予報カード
    private var todayForecastCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今日の予報")
                    .font(.headline)
                
                Spacer()
                
                if let maxUV = uvManager.todayMaxUVIndex {
                    Text("最大: \(maxUV)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            if uvManager.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if !uvManager.todayUVForecast.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(uvManager.todayUVForecast.indices, id: \.self) { index in
                            let hourlyUV = uvManager.todayUVForecast[index]
                            
                            VStack(spacing: 8) {
                                Text(hourlyUV.hour, formatter: hourFormatter)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("\(hourlyUV.uvIndex)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(colorForCategory(hourlyUV.category))
                                
                                Circle()
                                    .fill(colorForCategory(hourlyUV.category))
                                    .frame(width: 8, height: 8)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("予報データが取得できませんでした")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    /// リフレッシュボタン
    private var refreshButton: some View {
        Button(action: {
            uvManager.loadAllUVData()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("データを更新")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .disabled(uvManager.isLoading)
    }
    
    // MARK: - Helper Methods
    
    /// カテゴリに応じた色を取得
    /// - Parameter category: UV指数カテゴリ
    /// - Returns: SwiftUIのColor
    private func colorForCategory(_ category: UVIndexCategory) -> Color {
        switch category {
        case .low:
            return .green
        case .moderate:
            return .yellow
        case .high:
            return .orange
        case .veryHigh:
            return .red
        case .extreme:
            return .purple
        }
    }
}

// MARK: - Formatters

/// 時刻フォーマッター（HH:mm形式）
private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

/// 時間フォーマッター（H時形式）
private let hourFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "H時"
    return formatter
}()

// MARK: - Preview

@available(iOS 16.0, *)
struct UVIndexView_Previews: PreviewProvider {
    static var previews: some View {
        UVIndexView()
    }
}
