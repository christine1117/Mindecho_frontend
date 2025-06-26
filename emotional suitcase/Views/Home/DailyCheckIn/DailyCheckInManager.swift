import SwiftUI
import Foundation

// MARK: - 每日檢測分數模型
struct DailyCheckInScores: Codable {
    let physical: Int      // 生理健康
    let mental: Int        // 精神狀態
    let emotional: Int     // 情緒狀態
    let sleep: Int         // 睡眠品質
    let appetite: Int      // 飲食表現
    let date: Date
    
    var overall: Int {
        (physical + mental + emotional + sleep + appetite) / 5
    }
}

// MARK: - 每日檢測數據管理器
class DailyCheckInManager: ObservableObject {
    static let shared = DailyCheckInManager()
    
    @Published var todayScores: DailyCheckInScores?
    @Published var weeklyScores: [DailyCheckInScores] = []
    @Published var hasCompletedToday: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let todayScoresKey = "todayScores"
    private let weeklyScoresKey = "weeklyScores"
    
    init() {
        loadTodayScores()
        loadWeeklyScores()
        checkIfCompletedToday()
    }
    
    // MARK: - 保存今日檢測
    func saveDailyCheckIn(scores: DailyCheckInScores) {
        // 保存今日分數
        todayScores = scores
        hasCompletedToday = true
        
        // 保存到 UserDefaults
        if let data = try? JSONEncoder().encode(scores) {
            userDefaults.set(data, forKey: todayScoresKey)
        }
        
        // 添加到週數據
        addToWeeklyScores(scores)
        
        // 通知 UI 更新
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - 載入今日分數
    private func loadTodayScores() {
        guard let data = userDefaults.data(forKey: todayScoresKey),
              let scores = try? JSONDecoder().decode(DailyCheckInScores.self, from: data) else {
            return
        }
        
        // 檢查是否是今天的數據
        if Calendar.current.isDateInToday(scores.date) {
            todayScores = scores
        } else {
            // 如果不是今天的數據，清除
            userDefaults.removeObject(forKey: todayScoresKey)
            todayScores = nil
        }
    }
    
    // MARK: - 載入歷史數據
    private func loadWeeklyScores() {
        guard let data = userDefaults.data(forKey: weeklyScoresKey),
              let scores = try? JSONDecoder().decode([DailyCheckInScores].self, from: data) else {
            weeklyScores = []
            return
        }
        
        // 保留所有數據，不再限制為7天
        weeklyScores = scores
        saveWeeklyScores()
    }
    
    // MARK: - 添加到歷史數據
    private func addToWeeklyScores(_ scores: DailyCheckInScores) {
        // 檢查今天是否已有記錄
        let today = Calendar.current.startOfDay(for: Date())
        weeklyScores.removeAll { Calendar.current.startOfDay(for: $0.date) == today }
        
        // 添加新記錄
        weeklyScores.append(scores)
        
        // 按日期排序，最新的在前
        weeklyScores.sort { $0.date > $1.date }
        
        saveWeeklyScores()
    }
    
    // MARK: - 保存歷史數據
    private func saveWeeklyScores() {
        if let data = try? JSONEncoder().encode(weeklyScores) {
            userDefaults.set(data, forKey: weeklyScoresKey)
        }
    }
    
    // MARK: - 檢查今天是否已完成 [修正這裡]
    private func checkIfCompletedToday() {
        hasCompletedToday = todayScores != nil  // 修正：正確檢查是否有今日數據
    }
    
    // MARK: - 獲取特定時間範圍的數據
    func getDataForPeriod(_ period: String, indicator: HealthIndicatorType) -> [Int] {
        let calendar = Calendar.current
        var data: [Int] = []
        var dayCount: Int
        
        switch period {
        case "本週":
            dayCount = 7
        case "本月":
            dayCount = 30
        default:
            dayCount = 7
        }
        
        // 本週和本月都使用每天取樣
        for i in (0..<dayCount).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let dayStart = calendar.startOfDay(for: date)
            
            if let dayScore = weeklyScores.first(where: {
                calendar.startOfDay(for: $0.date) == dayStart
            }) {
                switch indicator {
                case .physical:
                    data.append(dayScore.physical)
                case .mental:
                    data.append(dayScore.mental)
                case .emotional:
                    data.append(dayScore.emotional)
                case .sleep:
                    data.append(dayScore.sleep)
                case .appetite:
                    data.append(dayScore.appetite)
                case .overall:
                    data.append(dayScore.overall)
                }
            } else {
                data.append(0)
            }
        }
        
        return data
    }
    
    // MARK: - 獲取時間標籤（分別獲取月份和日期）
    func getDateLabelsForPeriod(_ period: String) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        var labels: [String] = []
        var dayCount: Int
        
        switch period {
        case "本週":
            dayCount = 7
            dateFormatter.dateFormat = "E" // 週一、週二...
            
            // 本週顯示所有天，但縮短格式
            for i in (0..<dayCount).reversed() {
                let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                let fullDay = dateFormatter.string(from: date)
                // 縮短星期格式：週一->一, 週二->二
                let shortDay = fullDay.replacingOccurrences(of: "週", with: "")
                labels.append(shortDay)
            }
            
        case "本月":
            dayCount = 30
            
            // 本月每5天顯示一次
            for i in (0..<dayCount).reversed() {
                let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                
                if i % 5 == 0 { // 每5天顯示一次
                    let month = calendar.component(.month, from: date)
                    let day = calendar.component(.day, from: date)
                    labels.append("\(month)|\(day)") // 用|分隔月份和日期，稍後拆分
                } else {
                    labels.append("") // 空字符串保持位置
                }
            }
            
        default:
            dayCount = 7
            dateFormatter.dateFormat = "E"
            for i in (0..<dayCount).reversed() {
                let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                labels.append(dateFormatter.string(from: date))
            }
        }
        
        return labels
    }
    
    // MARK: - 獲取今日特定指標分數
    func getTodayScore(for indicator: HealthIndicatorType) -> Int {
        guard let todayScores = todayScores else { return 0 }
        
        switch indicator {
        case .physical:
            return todayScores.physical
        case .mental:
            return todayScores.mental
        case .emotional:
            return todayScores.emotional
        case .sleep:
            return todayScores.sleep
        case .appetite:
            return todayScores.appetite
        case .overall:
            return todayScores.overall
        }
    }
    
    // MARK: - 獲取平均分數（兼容性方法）
    func getAverageScore(for indicator: HealthIndicatorType, days: Int = 7) -> Int {
        let data = getDataForPeriod("本週", indicator: indicator).filter { $0 > 0 }
        guard !data.isEmpty else { return 0 }
        
        let sum = data.moodAngryuce(0, +)
        return sum / data.count
    }
    
    // MARK: - 獲取週數據（兼容性方法）
    func getWeeklyData(for indicator: HealthIndicatorType) -> [Int] {
        return getDataForPeriod("本週", indicator: indicator)
    }
    
    // MARK: - 重置今日數據（測試用）
    func resetTodayData() {
        todayScores = nil
        hasCompletedToday = false
        userDefaults.removeObject(forKey: todayScoresKey)
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - 清除所有數據（測試用）
    func clearAllData() {
        todayScores = nil
        hasCompletedToday = false
        weeklyScores = []
        userDefaults.removeObject(forKey: todayScoresKey)
        userDefaults.removeObject(forKey: weeklyScoresKey)
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// MARK: - 健康指標類型
enum HealthIndicatorType {
    case physical   // 生理健康
    case mental     // 精神狀態
    case emotional  // 情緒狀態
    case sleep      // 睡眠品質
    case appetite   // 飲食表現
    case overall    // 綜合指標
    
    var title: String {
        switch self {
        case .physical: return "生理健康"
        case .mental: return "精神狀態"
        case .emotional: return "情緒狀態"
        case .sleep: return "睡眠品質"
        case .appetite: return "飲食表現"
        case .overall: return "綜合指標"
        }
    }
    
    var color: Color {
        switch self {
        case .physical: return .moodAngry
        case .mental: return .blue
        case .emotional: return .purple
        case .sleep: return .indigo
        case .appetite: return .orange
        case .overall: return .moodCalm
        }
    }
}
