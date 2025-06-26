import Foundation

func formatDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    if calendar.isDateInToday(date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    } else if calendar.isDateInYesterday(date) {
        return "昨天"
    } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(date) == true {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        return formatter.string(from: date)
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
} 