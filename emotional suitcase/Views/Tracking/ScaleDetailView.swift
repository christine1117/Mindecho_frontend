// ScaleTracking/ScaleDetailView.swift
import SwiftUI

struct ScaleDetailView: View {
    let scale: ScaleType
    let records: [ScaleRecord]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 量表資訊
                    SectionCard(title: scale.rawValue, subtitle: scale.fullName) {
                        VStack(alignment: .leading, spacing: 10) {
                            if let latestRecord = records.first {
                                HStack {
                                    Text("最新分數:")
                                        .foregroundColor(.grayText)
                                    Spacer()
                                    Text("\(latestRecord.score)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(scale.color)
                                }
                                
                                HStack {
                                    Text("嚴重程度:")
                                        .foregroundColor(.grayText)
                                    Spacer()
                                    Text(latestRecord.severityLevel)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppColors.darkBrown)
                                }
                            } else {
                                Text("尚無測驗記錄")
                                    .foregroundColor(.grayText)
                            }
                        }
                    }
                    
                    // 歷史記錄
                    if !records.isEmpty {
                        SectionCard(title: "歷史記錄") {
                            ScaleHistoryList(records: records) { _ in }
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(AppColors.lightYellow)
            .navigationTitle(scale.rawValue)
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

#Preview {
    ScaleDetailView(scale: .phq9, records: [])
}
