import SwiftUI

struct MetricDisplayView: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let trendValue: Double?
    let backgroundColor: Color
    let accentColor: Color
    
    init(
        title: String,
        value: String,
        unit: String,
        icon: String,
        trendValue: Double? = nil,
        backgroundColor: Color = Color.white,
        accentColor: Color = AppColors.orange
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.icon = icon
        self.trendValue = trendValue
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 標題和圖標
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(accentColor)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppColors.darkBrown)
                    .lineLimit(1)
                
                Spacer()
                
                // 趨勢指示器
                if let trend = trendValue {
                    HStack(spacing: 2) {
                        Image(systemName: trend > 0 ? "arrow.up" : trend < 0 ? "arrow.down" : "minus")
                            .font(.caption2)
                            .foregroundColor(trend > 0 ? .moodCalm : trend < 0 ? .moodAngry : .grayText)
                        
                        Text("\(abs(trend), specifier: "%.1f")%")
                            .font(.caption2)
                            .foregroundColor(trend > 0 ? .moodCalm : trend < 0 ? .moodAngry : .grayText)
                    }
                }
            }
            
            // 數值顯示
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.darkBrown)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.grayText)
                
                Spacer()
            }
            
            // 簡化的趨勢圖
            if trendValue != nil {
                MiniTrendLine(accentColor: accentColor)
                    .frame(height: 20)
            }
        }
        .padding(15)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

struct MiniTrendLine: View {
    let accentColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // 簡單的趨勢線數據
                let points: [CGFloat] = [0.7, 0.5, 0.8, 0.3, 0.6, 0.4, 0.9]
                
                for (index, point) in points.enumerated() {
                    let x = CGFloat(index) * (width / CGFloat(points.count - 1))
                    let y = height * (1 - point)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 15) {
        MetricDisplayView(
            title: "心率變異性",
            value: "48",
            unit: "ms",
            icon: "heart.fill",
            trendValue: 2.3,
            accentColor: .moodAngry
        )
        
        MetricDisplayView(
            title: "睡眠質量",
            value: "2.4",
            unit: "小時",
            icon: "moon.fill",
            trendValue: -1.2,
            accentColor: .blue
        )
        
        MetricDisplayView(
            title: "活動量",
            value: "7200",
            unit: "步",
            icon: "figure.walk",
            trendValue: 5.7,
            accentColor: .moodCalm
        )
        
        MetricDisplayView(
            title: "體重",
            value: "53.2",
            unit: "公斤",
            icon: "scalemass.fill",
            accentColor: .purple
        )
    }
    .padding()
    .background(AppColors.lightYellow)
}
