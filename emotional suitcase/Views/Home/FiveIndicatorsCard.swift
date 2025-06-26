import SwiftUI

struct FiveIndicatorsCard: View {
    @Binding var selectedTimePeriod: String
    @ObservedObject private var checkInManager = DailyCheckInManager.shared
    @State private var showingDropdown = false

    let timePeriodOptions = ["本週", "本月"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("五項指標追蹤")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)

                Spacer()

                Menu {
                    ForEach(timePeriodOptions, id: \.self) { option in
                        Button(action: {
                            selectedTimePeriod = option
                        }) {
                            Text(option)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimePeriod)
                            .font(.caption)
                            .foregroundColor(AppColors.brownDeep.opacity(0.7))
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(AppColors.brownDeep.opacity(0.7))
                    }
                }
            }

            // 圖例
            HStack(spacing: 12) {
                indicatorLegend(name: "生理", color: .moodAngry)
                indicatorLegend(name: "心情", color: .blue)
                indicatorLegend(name: "睡眠", color: .purple)
                indicatorLegend(name: "精神", color: .orange)
                indicatorLegend(name: "食慾", color: .moodCalm)
            }

            // 圖表和標籤組合
            VStack(spacing: 4) {
                // 圖表區域
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let dataLabels = checkInManager.getDateLabelsForPeriod(selectedTimePeriod)
                    let dayCount = dataLabels.count
                    let dayWidth = dayCount > 1 ? width / CGFloat(dayCount - 1) : width

                    ZStack {
                        // 背景網格線
                        Path { path in
                            for i in 0..<5 {
                                let y = height * CGFloat(i) / 4
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                        }
                        .stroke(Color.grayText.opacity(0.1), lineWidth: 0.5)
                        
                        // 生理指標線條
                        createIndicatorLine(
                            data: checkInManager.getDataForPeriod(selectedTimePeriod, indicator: .physical),
                            color: .moodAngry,
                            width: width,
                            height: height,
                            dayWidth: dayWidth
                        )
                        
                        // 情緒指標線條
                        createIndicatorLine(
                            data: checkInManager.getDataForPeriod(selectedTimePeriod, indicator: .emotional),
                            color: .blue,
                            width: width,
                            height: height,
                            dayWidth: dayWidth
                        )
                        
                        // 睡眠指標線條
                        createIndicatorLine(
                            data: checkInManager.getDataForPeriod(selectedTimePeriod, indicator: .sleep),
                            color: .purple,
                            width: width,
                            height: height,
                            dayWidth: dayWidth
                        )
                        
                        // 精神指標線條
                        createIndicatorLine(
                            data: checkInManager.getDataForPeriod(selectedTimePeriod, indicator: .mental),
                            color: .orange,
                            width: width,
                            height: height,
                            dayWidth: dayWidth
                        )
                        
                        // 食慾指標線條
                        createIndicatorLine(
                            data: checkInManager.getDataForPeriod(selectedTimePeriod, indicator: .appetite),
                            color: .moodCalm,
                            width: width,
                            height: height,
                            dayWidth: dayWidth
                        )
                        
                        // 如果沒有數據，顯示提示
                        if checkInManager.weeklyScores.isEmpty {
                            VStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(.grayText.opacity(0.3))
                                Text("暫無數據")
                                    .font(.caption)
                                    .foregroundColor(.grayText.opacity(0.6))
                                Text("完成每日檢測後查看趨勢")
                                    .font(.caption2)
                                    .foregroundColor(.grayText.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .frame(height: 200)
                
                // 日期標籤 - 雙行顯示
                HStack(spacing: 0) {
                    ForEach(Array(checkInManager.getDateLabelsForPeriod(selectedTimePeriod).enumerated()), id: \.offset) { index, day in
                        if selectedTimePeriod == "本月" && !day.isEmpty {
                            // 本月：雙行顯示（月份和日期分開）
                            let parts = day.components(separatedBy: "|")
                            VStack(spacing: 1) {
                                Text(parts.first ?? "")
                                    .font(.caption2)
                                    .foregroundColor(AppColors.brownDeep.opacity(0.6))
                                Text(parts.last ?? "")
                                    .font(.caption2)
                                    .foregroundColor(AppColors.brownDeep)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity, minHeight: 24)
                        } else {
                            // 本週：單行顯示
                            Text(day)
                                .font(.caption2)
                                .foregroundColor(AppColors.brownDeep)
                                .frame(maxWidth: .infinity, minHeight: 24)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
    
    // MARK: - 輔助方法
    
    /// 創建圖例項目
    private func indicatorLegend(name: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(name)
                .font(.caption2)
                .foregroundColor(AppColors.brownDeep.opacity(0.8))
        }
    }
    
    /// 創建指標線條
    private func createIndicatorLine(
        data: [Int],
        color: Color,
        width: CGFloat,
        height: CGFloat,
        dayWidth: CGFloat
    ) -> some View {
        ZStack {
            // 線條
            Path { path in
                for i in 0..<data.count {
                    let x = CGFloat(i) * dayWidth
                    let normalizedValue = CGFloat(data[i]) / 100.0
                    let y = height - (normalizedValue * height)

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, lineWidth: 2)
            
            // 數據點
            ForEach(Array(data.enumerated()), id: \.offset) { i, value in
                if value > 0 {
                    Circle()
                        .fill(color)
                        .frame(width: 4, height: 4)
                        .position(
                            x: CGFloat(i) * dayWidth,
                            y: height - (CGFloat(value) / 100.0 * height)
                        )
                }
            }
        }
    }
    
    /// 獲取日期標籤（移除，改用 DailyCheckInManager 的方法）
    // private var dayLabels: [String] { ... } // 已移除
}

#Preview {
    FiveIndicatorsCard(selectedTimePeriod: .constant("本週"))
        .padding()
        .background(AppColors.backgroundLight)
}
