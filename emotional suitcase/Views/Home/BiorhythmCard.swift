import SwiftUI

struct BiorhythmCard: View {
    let physicalBiorhythm: Double
    let emotionalBiorhythm: Double
    let intellectualBiorhythm: Double
    let currentDate: Date
    let animationProgress: Double
    let onEditTapped: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter
    }
    
    // 轉換為百分比
    private func toPercentage(_ value: Double) -> Int {
        return Int((value + 1) * 0.5 * 100)
    }
    
    // 檢查是否為閏年
    private func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
    // 獲取當前指針角度 - 基於當前日期在一年中的位置
    private func getCurrentPointerAngle() -> Double {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentDate) ?? 1
        
        // 計算一年的總天數
        let totalDaysInYear = isLeapYear(year) ? 366 : 365
        
        // 計算指針角度：直接基於在一年中的位置
        return 360.0 / Double(totalDaysInYear) * Double(dayOfYear)
    }
    
    // 計算生理節律圓環的旋轉角度
    private func getBiorhythmRingRotation(_ biorhythmValue: Double, pointerAngle: Double) -> Double {
        // 將-1到1的生理節律值轉換為0到100的百分比
        let percentage = (biorhythmValue + 1) * 0.5 * 100
        
        // 簡化為5個切分點：0%, 25%, 50%, 75%, 100%
        // 每個切分點對應360/4 = 90度
        let gradientAngle = (100 - percentage) * 3.6  // 每1%對應3.6度
        
        // 計算需要旋轉多少度，讓對應顏色出現在指針位置
        return pointerAngle - gradientAngle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("生理節律")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                
                Spacer()
                
                Button(action: onEditTapped) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(AppColors.brownDeep)
                        .font(.title2)
                }
            }
            
            HStack(spacing: 20) {
                // 左側圓環圖表
                VStack(alignment: .leading, spacing: 16) {
                    // 中心日期 - 移到圓環上方更遠的位置
                    HStack {
                        Spacer()
                        Text(dateFormatter.string(from: currentDate))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.brownDeep)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    ZStack {
                        // 最外層漸層圓環 - 身體狀態 (橘紅漸層，像參考圖片)
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.9, blue: 0.7),   // 100% - 淺橘色
                                        Color(red: 1.0, green: 0.8, blue: 0.5),   // 75%
                                        Color(red: 1.0, green: 0.6, blue: 0.3),   // 50%
                                        Color(red: 0.9, green: 0.4, blue: 0.2),   // 25%
                                        Color(red: 0.7, green: 0.2, blue: 0.1),   // 0% - 深橘紅
                                        Color(red: 0.9, green: 0.4, blue: 0.2),   // 25%
                                        Color(red: 1.0, green: 0.6, blue: 0.3),   // 50%
                                        Color(red: 1.0, green: 0.8, blue: 0.5),   // 75%
                                        Color(red: 1.0, green: 0.9, blue: 0.7)    // 100%
                                    ],
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                ),
                                lineWidth: 30
                            )
                            .frame(width: 140, height: 140)
                            .rotationEffect(.degrees(getBiorhythmRingRotation(physicalBiorhythm, pointerAngle: getCurrentPointerAngle()) * animationProgress))
                            .animation(.easeInOut(duration: 2.0), value: animationProgress)
                        
                        // 中層圓環 - 情緒狀態 (金黃漸層)
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    colors: [
                                        Color(red: 1.0, green: 1.0, blue: 0.8),   // 100% - 淺金色
                                        Color(red: 1.0, green: 0.9, blue: 0.5),   // 75%
                                        Color(red: 1.0, green: 0.8, blue: 0.3),   // 50%
                                        Color(red: 0.8, green: 0.6, blue: 0.2),   // 25%
                                        Color(red: 0.6, green: 0.4, blue: 0.1),   // 0% - 深金色
                                        Color(red: 0.8, green: 0.6, blue: 0.2),   // 25%
                                        Color(red: 1.0, green: 0.8, blue: 0.3),   // 50%
                                        Color(red: 1.0, green: 0.9, blue: 0.5),   // 75%
                                        Color(red: 1.0, green: 1.0, blue: 0.8)    // 100%
                                    ],
                                    center: .center
                                ),
                                lineWidth: 20
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(getBiorhythmRingRotation(emotionalBiorhythm, pointerAngle: getCurrentPointerAngle()) * animationProgress))
                            .animation(.easeInOut(duration: 2.0).delay(0.3), value: animationProgress)
                        
                        // 內層圓環 - 智力狀態 (咖啡漸層)
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    colors: [
                                        Color(red: 0.9, green: 0.8, blue: 0.6),   // 100% - 淺咖啡色
                                        Color(red: 0.8, green: 0.6, blue: 0.4),   // 75%
                                        Color(red: 0.7, green: 0.5, blue: 0.3),   // 50%
                                        Color(red: 0.5, green: 0.3, blue: 0.2),   // 25%
                                        Color(red: 0.3, green: 0.2, blue: 0.1),   // 0% - 深咖啡色
                                        Color(red: 0.5, green: 0.3, blue: 0.2),   // 25%
                                        Color(red: 0.7, green: 0.5, blue: 0.3),   // 50%
                                        Color(red: 0.8, green: 0.6, blue: 0.4),   // 75%
                                        Color(red: 0.9, green: 0.8, blue: 0.6)    // 100%
                                    ],
                                    center: .center
                                ),
                                lineWidth: 15
                            )
                            .frame(width: 65, height: 65)
                            .rotationEffect(.degrees(getBiorhythmRingRotation(intellectualBiorhythm, pointerAngle: getCurrentPointerAngle()) * animationProgress))
                            .animation(.easeInOut(duration: 2.0).delay(0.6), value: animationProgress)
                        
                        // 外圍月份刻度
                        ForEach(0..<12, id: \.self) { month in
                            let angle = Double(month) * 30 - 90
                            let radians = angle * .pi * (1.0/180.0)
                            let radius: CGFloat = 85
                            
                            Text("\(month + 1)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.brownDeep)
                                .offset(
                                    x: cos(radians) * radius,
                                    y: sin(radians) * radius
                                )
                        }
                        
                        // 主指針 - 指向當前日期在一年中的位置
                        let mainPointerAngle = getCurrentPointerAngle()
                        Rectangle()
                            .fill(AppColors.brownDeep)
                            .frame(width: 3, height: 60)
                            .offset(y: -30)
                            .rotationEffect(.degrees(mainPointerAngle * animationProgress))
                            .animation(.easeInOut(duration: 2.0), value: animationProgress)
                        
                        // 中心圓點
                        Circle()
                            .fill(AppColors.brownDeep)
                            .frame(width: 12, height: 12)
                    }
                    .frame(width: 160, height: 160)
                    
                    // 圓環指標說明 - 更新顏色
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color(red: 1.0, green: 0.9, blue: 0.7))
                                .frame(width: 12, height: 4)
                            Text("身體 (外圈)")
                                .font(.caption2)
                                .foregroundColor(AppColors.brownDeep)
                        }
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color(red: 1.0, green: 1.0, blue: 0.8))
                                .frame(width: 12, height: 4)
                            Text("情緒 (中圈)")
                                .font(.caption2)
                                .foregroundColor(AppColors.brownDeep)
                        }
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color(red: 0.9, green: 0.8, blue: 0.6))
                                .frame(width: 12, height: 4)
                            Text("智力 (內圈)")
                                .font(.caption2)
                                .foregroundColor(AppColors.brownDeep)
                        }
                    }
                }
                
                // 右側數據
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Circle()
                                .fill(AppColors.brownDeep)
                                .frame(width: 8, height: 8)
                            Text("身體狀態：\(toPercentage(physicalBiorhythm))%")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.brownDeep)
                                .opacity(animationProgress)
                                .animation(.easeInOut(duration: 1.0).delay(0.5), value: animationProgress)
                        }
                        Text(getPhysicalDescription(physicalBiorhythm))
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.brownDeep)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(animationProgress)
                            .animation(.easeInOut(duration: 1.0).delay(0.7), value: animationProgress)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Circle()
                                .fill(Color(red: 0.9, green: 0.5, blue: 0.1))
                                .frame(width: 8, height: 8)
                            Text("情緒狀態：\(toPercentage(emotionalBiorhythm))%")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.brownDeep)
                                .opacity(animationProgress)
                                .animation(.easeInOut(duration: 1.0).delay(0.9), value: animationProgress)
                        }
                        Text(getEmotionalDescription(emotionalBiorhythm))
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.brownDeep)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(animationProgress)
                            .animation(.easeInOut(duration: 1.0).delay(1.1), value: animationProgress)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Circle()
                                .fill(Color(red: 1.0, green: 0.8, blue: 0.3))
                                .frame(width: 8, height: 8)
                            Text("智力狀態：\(toPercentage(intellectualBiorhythm))%")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(AppColors.brownDeep)
                                .opacity(animationProgress)
                                .animation(.easeInOut(duration: 1.0).delay(1.3), value: animationProgress)
                        }
                        Text(getIntellectualDescription(intellectualBiorhythm))
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.brownDeep)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(animationProgress)
                            .animation(.easeInOut(duration: 1.0).delay(1.5), value: animationProgress)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
    
    // 動態生理節律描述
    private func getPhysicalDescription(_ value: Double) -> String {
        let percentage = toPercentage(value)
        if percentage >= 75 {
            return "你的身體狀態極佳，精力充沛。非常適合進行體力活動和運動訓練。"
        } else if percentage >= 50 {
            return "你的身體狀態良好，精力充足。適合進行適度的體力活動。"
        } else if percentage >= 25 {
            return "你的身體狀態一般，精力稍顯不足。建議適量運動，注意休息。"
        } else {
            return "你的身體狀態較弱，精力不足。建議多休息，避免過度勞累。"
        }
    }
    
    private func getEmotionalDescription(_ value: Double) -> String {
        let percentage = toPercentage(value)
        if percentage >= 75 {
            return "你的情緒狀態極佳，心情愉悅。非常適合處理社交活動和重要人際互動。"
        } else if percentage >= 50 {
            return "你的情緒狀態平穩，情緒控制良好。適合處理社交活動和一般人際互動。"
        } else if percentage >= 25 {
            return "你的情緒狀態一般，可能稍有波動。建議保持平和心態。"
        } else {
            return "你的情緒狀態較低，可能感到煩躁。建議避免重要決定，多放鬆休息。"
        }
    }
    
    private func getIntellectualDescription(_ value: Double) -> String {
        let percentage = toPercentage(value)
        if percentage >= 75 {
            return "你的智力狀態極佳，思維敏銳。非常適合處理複雜的思考任務和學習。"
        } else if percentage >= 50 {
            return "你的智力狀態良好，思維清晰。適合處理一般的思考任務。"
        } else if percentage >= 25 {
            return "你的智力狀態一般，思維效率稍低。建議處理簡單任務，避免複雜思考。"
        } else {
            return "你的智力狀態較弱，可能感到思維不夠清晰。建議避免處理複雜的思考任務。"
        }
    }
}
