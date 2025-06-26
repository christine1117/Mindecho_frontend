// MoodDiary/MoodCalendarView.swift
import SwiftUI

struct MoodCalendarView: View {
    @ObservedObject var trackingManager: TrackingDataManager
    @Binding var selectedDate: Date
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 15) {
            // 月份導航
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.orange)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.darkBrown)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.orange)
                }
            }
            
            // 星期標題
            HStack {
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.grayText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 日期網格 - 只顯示當月日期
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInCurrentMonth(), id: \.self) { date in
                    if calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) {
                        // 當月日期
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            moodEntry: getMoodEntry(for: date),
                            onTap: {
                                selectedDate = date
                            }
                        )
                    } else {
                        // 空白佔位符
                        Color.clear
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
    }
    
    private func getDaysInCurrentMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        var days: [Date] = []
        
        // 添加空白日期以對齊星期
        for _ in 1..<firstWeekday {
            days.append(Date.distantPast) // 使用特殊日期作為佔位符
        }
        
        // 添加當月的所有日期
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
        for i in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func getMoodEntry(for date: Date) -> MoodEntry? {
        return trackingManager.moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let moodEntry: MoodEntry?
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : AppColors.darkBrown)
                
                if let mood = moodEntry?.mood {
                    Text(mood.emoji)
                        .font(.caption2)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(width: 35, height: 35)
            .background(
                Circle()
                    .fill(isSelected ? AppColors.orange : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MoodCalendarView(
        trackingManager: TrackingDataManager(),
        selectedDate: .constant(Date())
    )
    .padding()
}
