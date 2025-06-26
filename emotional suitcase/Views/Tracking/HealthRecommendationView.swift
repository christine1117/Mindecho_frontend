// HealthData/HealthRecommendationView.swift
import SwiftUI

struct HealthRecommendationView: View {
    @ObservedObject var trackingManager: TrackingDataManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 個人化建議
                    SectionCard(title: "個人化健康建議") {
                        VStack(alignment: .leading, spacing: 15) {
                            RecommendationItem(
                                icon: "heart.fill",
                                title: "心率變異性改善",
                                description: "建議進行深呼吸練習和冥想，有助於提升心率變異性。",
                                color: .moodAngry
                            )
                            
                            RecommendationItem(
                                icon: "moon.fill",
                                title: "睡眠質量優化",
                                description: "建議睡前1小時避免使用電子設備，保持規律作息。",
                                color: .blue
                            )
                            
                            RecommendationItem(
                                icon: "figure.walk",
                                title: "活動量提升",
                                description: "建議每天增加2000步，可以選擇走樓梯或散步。",
                                color: .moodCalm
                            )
                        }
                    }
                    
                    // 健康目標
                    SectionCard(title: "本週健康目標") {
                        VStack(spacing: 12) {
                            HealthGoalItem(title: "每日步數", current: 7200, target: 10000)
                            HealthGoalItem(title: "睡眠時間", current: 6.5, target: 8.0)
                            HealthGoalItem(title: "運動次數", current: 3, target: 5)
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(AppColors.lightYellow)
            .navigationTitle("健康建議")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.orange)
                }
            }
        }
    }
}

struct RecommendationItem: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkBrown)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct HealthGoalItem: View {
    let title: String
    let current: Double
    let target: Double
    
    var progress: Double {
        min(current / target, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.darkBrown)
                
                Spacer()
                
                Text("\(current, specifier: "%.0f")/\(target, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundColor(.grayText)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: AppColors.orange))
        }
    }
}

#Preview {
    HealthRecommendationView(trackingManager: TrackingDataManager())
}
