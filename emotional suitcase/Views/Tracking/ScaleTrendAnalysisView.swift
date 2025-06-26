// ScaleTracking/ScaleTrendAnalysisView.swift
import SwiftUI
import Charts

struct ScaleTrendAnalysisView: View {
    let scale: ScaleType
    let records: [ScaleRecord]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeRange: TimeRange = .sixMonths
    
    enum TimeRange: String, CaseIterable {
        case threeMonths = "3個月"
        case sixMonths = "6個月"
        case oneYear = "1年"
        
        var months: Int {
            switch self {
            case .threeMonths: return 3
            case .sixMonths: return 6
            case .oneYear: return 12
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 時間範圍選擇
                    SectionCard(title: "時間範圍") {
                        HStack(spacing: 10) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Button(action: {
                                    selectedTimeRange = range
                                }) {
                                    Text(range.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedTimeRange == range ? .white : scale.color)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedTimeRange == range ? scale.color : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(scale.color, lineWidth: 1)
                                        )
                                        .cornerRadius(8)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    // 趨勢圖表
                    SectionCard(title: "趨勢分析", subtitle: "每月平均分數變化") {
                        ScaleTrendChart(
                            scale: scale,
                            monthlyData: getMonthlyData(),
                            timeRange: selectedTimeRange
                        )
                    }
                    
                    // 統計摘要
                    SectionCard(title: "統計摘要") {
                        ScaleStatsSummary(
                            scale: scale,
                            records: getFilteredRecords()
                        )
                    }
                    
                    // 月度記錄列表
                    SectionCard(title: "詳細記錄") {
                        MonthlyRecordsList(
                            monthlyData: getMonthlyData(),
                            scale: scale
                        )
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(AppColors.lightYellow)
            .navigationTitle("\(scale.rawValue) 趨勢分析")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("關閉") {
                        dismiss()
                    }
                    .foregroundColor(scale.color)
                }
            }
        }
    }
    
    private func getFilteredRecords() -> [ScaleRecord] {
        let calendar = Calendar.current
        let cutoffDate = calendar.date(byAdding: .month, value: -selectedTimeRange.months, to: Date()) ?? Date()
        
        return records.filter { $0.date >= cutoffDate }
    }
    
    private func getMonthlyData() -> [MonthlyScaleData] {
        let filteredRecords = getFilteredRecords()
        let calendar = Calendar.current
        
        // 按月份分組
        let groupedRecords = Dictionary(grouping: filteredRecords) { record in
            let components = calendar.dateComponents([.year, .month], from: record.date)
            return "\(components.year!)-\(String(format: "%02d", components.month!))"
        }
        
        // 計算每月平均分數
        var monthlyData: [MonthlyScaleData] = []
        
        for (monthKey, monthRecords) in groupedRecords {
            let averageScore = Double(monthRecords.map { $0.score }.moodAngryuce(0, +)) / Double(monthRecords.count)
            let components = monthKey.split(separator: "-")
            let year = Int(components[0]) ?? 2024
            let month = Int(components[1]) ?? 1
            
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
                monthlyData.append(MonthlyScaleData(
                    date: date,
                    averageScore: averageScore,
                    recordCount: monthRecords.count
                ))
            }
        }
        
        return monthlyData.sorted { $0.date < $1.date }
    }
}

struct MonthlyScaleData: Identifiable {
    let id = UUID()
    let date: Date
    let averageScore: Double
    let recordCount: Int
}

struct ScaleTrendChart: View {
    let scale: ScaleType
    let monthlyData: [MonthlyScaleData]
    let timeRange: ScaleTrendAnalysisView.TimeRange
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if monthlyData.isEmpty {
                Text("暫無數據")
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                // 使用 Chart (需要 iOS 16+)
                if #available(iOS 16.0, *) {
                    Chart(monthlyData) { data in
                        LineMark(
                            x: .value("月份", data.date),
                            y: .value("分數", data.averageScore)
                        )
                        .foregroundStyle(scale.color)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        
                        PointMark(
                            x: .value("月份", data.date),
                            y: .value("分數", data.averageScore)
                        )
                        .foregroundStyle(scale.color)
                        .symbolSize(50)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month)) { value in
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text(dateFormatter.string(from: date))
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let score = value.as(Double.self) {
                                    Text("\(Int(score))")
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                } else {
                    // iOS 15 及以下的簡化版本
                    SimpleTrendChart(
                        data: monthlyData,
                        color: scale.color
                    )
                }
                
                // 圖表說明
                HStack {
                    Text("平均分數趨勢")
                        .font(.caption2)
                        .foregroundColor(.grayText)
                    Spacer()
                    Text("最高: \(Int(monthlyData.map { $0.averageScore }.max() ?? 0))")
                        .font(.caption2)
                        .foregroundColor(.grayText)
                }
            }
        }
    }
}

struct SimpleTrendChart: View {
    let data: [MonthlyScaleData]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let width = geometry.size.width
                let height = geometry.size.height
                let maxScore = data.map { $0.averageScore }.max() ?? 1
                let minScore = data.map { $0.averageScore }.min() ?? 0
                let scoreRange = maxScore - minScore
                
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * (width / CGFloat(data.count - 1))
                    let y = height - (CGFloat(point.averageScore - minScore) / CGFloat(scoreRange)) * height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 200)
    }
}

struct ScaleStatsSummary: View {
    let scale: ScaleType
    let records: [ScaleRecord]
    
    var averageScore: Double {
        guard !records.isEmpty else { return 0 }
        return Double(records.map { $0.score }.moodAngryuce(0, +)) / Double(records.count)
    }
    
    var highestScore: Int {
        records.map { $0.score }.max() ?? 0
    }
    
    var lowestScore: Int {
        records.map { $0.score }.min() ?? 0
    }
    
    var body: some View {
        HStack(spacing: 20) {
            StatItem(title: "平均分數", value: String(format: "%.1f", averageScore))
            StatItem(title: "最高分數", value: "\(highestScore)")
            StatItem(title: "最低分數", value: "\(lowestScore)")
            StatItem(title: "測驗次數", value: "\(records.count)")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.darkBrown)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.grayText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MonthlyRecordsList: View {
    let monthlyData: [MonthlyScaleData]
    let scale: ScaleType
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(monthlyData.reversed()) { data in
                HStack {
                    Text(monthFormatter.string(from: data.date))
                        .font(.caption)
                        .foregroundColor(AppColors.darkBrown)
                    
                    Spacer()
                    
                    Text("平均: \(String(format: "%.1f", data.averageScore))")
                        .font(.caption)
                        .foregroundColor(.grayText)
                    
                    Text("(\(data.recordCount)次)")
                        .font(.caption2)
                        .foregroundColor(.grayText)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    ScaleTrendAnalysisView(
        scale: .phq9,
        records: []
    )
}
