// HealthData/HealthRecommendationCard.swift
import SwiftUI

struct HealthRecommendationCard: View {
    let onViewMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(AppColors.orange)
                
                Text("根據你的數據分析")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkBrown)
                
                Spacer()
            }
            
            Text("建議增加每日步行量，保持良好的睡眠習慣有助於改善心率變異性。")
                .font(.caption)
                .foregroundColor(.grayText)
                .multilineTextAlignment(.leading)
            
            Button(action: onViewMore) {
                HStack {
                    Text("查看更多建議")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                }
                .foregroundColor(AppColors.orange)
            }
        }
        .padding()
        .background(AppColors.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    HealthRecommendationCard(onViewMore: {})
        .padding()
}
