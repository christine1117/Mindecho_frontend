import Foundation
import SwiftUI

final class DailyCheckInManager: ObservableObject {
    static let shared = DailyCheckInManager()
    @Published var scores: [DailyCheckInScores] = []
    
    private init() {
        loadSampleData()
    }
    
    func saveDailyCheckIn(scores: DailyCheckInScores) {
        // TODO: 儲存邏輯
        self.scores.append(scores)
    }
    
    func getDateLabelsForPeriod(_ period: Int) -> [String] {
        // TODO: 回傳日期標籤
        return []
    }
    
    var overallScore: Int {
        // TODO: 計算總分
        scores.last.map { $0.physical + $0.mental + $0.emotional + $0.sleep + $0.appetite } ?? 0
    }
    
    var statusColor: Color {
        // TODO: 根據分數回傳顏色
        let score = overallScore
        switch score {
        case 80...: return .moodCalm
        case 60..<80: return .yellow
        default: return .moodAngry
        }
    }
    
    var healthStatus: String {
        // TODO: 根據分數回傳狀態
        let score = overallScore
        switch score {
        case 80...: return "健康"
        case 60..<80: return "普通"
        default: return "需關注"
        }
    }
    
    // MARK: - 範例資料
    private func loadSampleData() {
        let sampleScores = DailyCheckInScores(
            physical: 8,
            mental: 7,
            emotional: 6,
            sleep: 8,
            appetite: 7,
            date: Date()
        )
        scores.append(sampleScores)
    }
    
    // 取得指定指標的分數陣列
    func getDataForPeriod(_ period: Int, indicator: String) -> [Int] {
        let recentScores = scores.suffix(period)
        switch indicator {
        case "physical":
            return recentScores.map { $0.physical }
        case "mental":
            return recentScores.map { $0.mental }
        case "emotional":
            return recentScores.map { $0.emotional }
        case "sleep":
            return recentScores.map { $0.sleep }
        case "appetite":
            return recentScores.map { $0.appetite }
        default:
            return []
        }
    }
} 