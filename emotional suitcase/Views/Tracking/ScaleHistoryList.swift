// ScaleTracking/ScaleHistoryList.swift
import SwiftUI

struct ScaleHistoryList: View {
    let records: [ScaleRecord]
    let onRecordTap: (ScaleRecord) -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(records) { record in
                Button(action: {
                    onRecordTap(record)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.type.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.darkBrown)
                            
                            Text(dateFormatter.string(from: record.date))
                                .font(.caption)
                                .foregroundColor(.grayText)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(record.score)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(record.type.color)
                            
                            Text(record.severityLevel)
                                .font(.caption2)
                                .foregroundColor(.grayText)
                        }
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.grayText)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    ScaleHistoryList(records: [], onRecordTap: { _ in })
        .padding()
}
