// ScaleTracking/ScaleHistoryCard.swift
import SwiftUI

struct ScaleHistoryCard: View {
    let scale: ScaleType
    let records: [ScaleRecord]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 量表圖標
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundColor(scale.color)
                
                // 量表名稱
                Text(scale.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.darkBrown)
                
                // 記錄數量
                Text("\(records.count)筆")
                    .font(.caption2)
                    .foregroundColor(.grayText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(scale.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 12) {
        ScaleHistoryCard(scale: .phq9, records: [], onTap: {})
        ScaleHistoryCard(scale: .gad7, records: [], onTap: {})
        ScaleHistoryCard(scale: .bsrs5, records: [], onTap: {})
        ScaleHistoryCard(scale: .rfq8, records: [], onTap: {})
    }
    .padding()
}
