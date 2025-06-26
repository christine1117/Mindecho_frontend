// ScaleTracking/ScaleSelectionCard.swift
import SwiftUI

struct ScaleSelectionCard: View {
    let scale: ScaleType
    let lastRecord: ScaleRecord?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(scale.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                }
                .padding()
                .background(scale.color)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(scale.fullName)
                        .font(.caption)
                        .foregroundColor(AppColors.darkBrown)
                    
                    if let record = lastRecord {
                        Text("最近分數: \(record.score)")
                            .font(.caption2)
                            .foregroundColor(.grayText)
                    } else {
                        Text("尚未測驗")
                            .font(.caption2)
                            .foregroundColor(.grayText)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
        ScaleSelectionCard(scale: .phq9, lastRecord: nil, onTap: {})
        ScaleSelectionCard(scale: .gad7, lastRecord: nil, onTap: {})
    }
    .padding()
}
