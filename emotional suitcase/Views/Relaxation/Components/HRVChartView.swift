import SwiftUI

struct HRVChartView: View {
    @ObservedObject private var hrvManager = HRVManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if hrvManager.isConnected && !hrvManager.hrvData.isEmpty {
                // HRV 圖表
                VStack(spacing: 12) {
                    // 設備狀態行
                    HStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.moodCalm)
                                .frame(width: 8, height: 8)
                            
                            Text(hrvManager.deviceName)
                                .font(.caption)
                                .foregroundColor(.grayText)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "battery.100")
                                .font(.caption)
                                .foregroundColor(.grayText)
                            
                            Text("\(hrvManager.batteryLevel)%")
                                .font(.caption)
                                .foregroundColor(.grayText)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // 當前數值顯示行 - 調整間距避免重疊
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("當前 HRV")
                                .font(.caption)
                                .foregroundColor(.grayText)
                            
                            HStack(spacing: 8) {
                                Text(String(format: "%.1f", hrvManager.currentHRV))
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.brownDeep)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: hrvManager.hrvTrend.icon)
                                        .font(.caption)
                                        .foregroundColor(hrvManager.hrvTrend.color)
                                    
                                    Text(hrvManager.hrvTrend.description)
                                        .font(.caption)
                                        .foregroundColor(hrvManager.hrvTrend.color)
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("平均值")
                                .font(.caption)
                                .foregroundColor(.grayText)
                            
                            Text(String(format: "%.1f", hrvManager.averageHRV))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.grayText)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // 實時圖表 - 增加高度避免擁擠
                    HRVLineChart(data: hrvManager.hrvData)
                        .frame(height: 80)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayText.opacity(0.2), lineWidth: 1)
                        )
                )
            } else if hrvManager.isConnected {
                // 連接但無數據
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.moodCalm)
                            .frame(width: 8, height: 8)
                        
                        Text("正在收集數據...")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayText.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
    }
}

// MARK: - HRV 線性圖表
struct HRVLineChart: View {
    let data: [HRVDataPoint]
    
    private let maxDataPoints = 60
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            if data.isEmpty {
                Text("暫無數據")
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZStack {
                    // 背景網格
                    GridBackground()
                    
                    // HRV 線條
                    HRVLinePath(data: recentData, width: width, height: height)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.orangeMain,
                                    Color(red: 0.6, green: 0.3, blue: 0.1)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                        )
                    
                    // 填充區域
                    HRVAreaPath(data: recentData, width: width, height: height)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.orangeMain.opacity(0.3),
                                    AppColors.orangeMain.opacity(0.1)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // 數據點
                    ForEach(Array(recentData.enumerated()), id: \.element.id) { index, dataPoint in
                        Circle()
                            .fill(dataPoint.quality.color)
                            .frame(width: 4, height: 4)
                            .position(
                                x: CGFloat(index) * (width / CGFloat(max(recentData.count - 1, 1))),
                                y: height - (normalizedValue(dataPoint.value) * height)
                            )
                    }
                }
            }
        }
    }
    
    private var recentData: [HRVDataPoint] {
        Array(data.suffix(maxDataPoints))
    }
    
    private var minValue: Double {
        recentData.map { $0.value }.min() ?? 0
    }
    
    private var maxValue: Double {
        recentData.map { $0.value }.max() ?? 100
    }
    
    private func normalizedValue(_ value: Double) -> CGFloat {
        let range = maxValue - minValue
        guard range > 0 else { return 0.5 }
        return CGFloat((value - minValue) / range)
    }
}

// MARK: - HRV 線條路徑
struct HRVLinePath: Shape {
    let data: [HRVDataPoint]
    let width: CGFloat
    let height: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard data.count > 1 else { return path }
        
        let minValue = data.map { $0.value }.min() ?? 0
        let maxValue = data.map { $0.value }.max() ?? 100
        let range = maxValue - minValue
        
        let stepWidth = width / CGFloat(max(data.count - 1, 1))
        
        for (index, dataPoint) in data.enumerated() {
            let x = CGFloat(index) * stepWidth
            let normalizedValue = range > 0 ? (dataPoint.value - minValue) / range : 0.5
            let y = height - (CGFloat(normalizedValue) * height)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

// MARK: - HRV 填充區域
struct HRVAreaPath: Shape {
    let data: [HRVDataPoint]
    let width: CGFloat
    let height: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard data.count > 1 else { return path }
        
        let minValue = data.map { $0.value }.min() ?? 0
        let maxValue = data.map { $0.value }.max() ?? 100
        let range = maxValue - minValue
        
        let stepWidth = width / CGFloat(max(data.count - 1, 1))
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for (index, dataPoint) in data.enumerated() {
            let x = CGFloat(index) * stepWidth
            let normalizedValue = range > 0 ? (dataPoint.value - minValue) / range : 0.5
            let y = height - (CGFloat(normalizedValue) * height)
            
            if index == 0 {
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - 網格背景
struct GridBackground: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(0..<3) { _ in
                    Divider()
                        .background(Color.grayText.opacity(0.2))
                    Spacer()
                }
                Divider()
                    .background(Color.grayText.opacity(0.2))
            }
            
            HStack(spacing: 0) {
                ForEach(0..<4) { _ in
                    Divider()
                        .background(Color.grayText.opacity(0.2))
                    Spacer()
                }
                Divider()
                    .background(Color.grayText.opacity(0.2))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HRVChartView()
            .frame(height: 140)
            .padding()
        
        HRVChartView()
            .frame(height: 140)
            .padding()
            .onAppear {
                HRVManager.shared.connectDevice()
            }
    }
    .background(AppColors.backgroundLight)
}
