import SwiftUI
import Foundation

// MARK: - 放鬆模式
enum RelaxationMode: String, CaseIterable, Codable {
    case breathing = "breathing"
    case meditation = "meditation"
    
    var displayName: String {
        switch self {
        case .breathing: return "呼吸"
        case .meditation: return "冥想"
        }
    }
    
    var shortName: String {
        switch self {
        case .breathing: return "呼吸"
        case .meditation: return "冥想"
        }
    }
    
    var color: Color {
        switch self {
        case .breathing: return Color(red: 0.9, green: 0.6, blue: 0.2)
        case .meditation: return AppColors.orangeMain
        }
    }
    
    var icon: String {
        switch self {
        case .breathing: return "wind"
        case .meditation: return "leaf"
        }
    }
}

// MARK: - 計時器狀態
enum TimerState: Codable {
    case stopped
    case running
    case paused
    case completed
}

// MARK: - 呼吸階段
enum BreathingPhase: String, CaseIterable, Codable {
    case inhale = "inhale"
    case hold = "hold"
    case exhale = "exhale"
    case pause = "pause"
    
    var displayName: String {
        switch self {
        case .inhale: return "吸氣"
        case .hold: return "屏息"
        case .exhale: return "呼氣"
        case .pause: return "暫停"
        }
    }
    
    var instruction: String {
        switch self {
        case .inhale: return "慢慢吸氣..."
        case .hold: return "保持..."
        case .exhale: return "緩緩呼氣..."
        case .pause: return "放鬆..."
        }
    }
    
    var color: Color {
        switch self {
        case .inhale: return Color.blue.opacity(0.7)
        case .hold: return Color.purple.opacity(0.7)
        case .exhale: return Color.moodCalm.opacity(0.7)
        case .pause: return Color.grayText.opacity(0.5)
        }
    }
}

// MARK: - 呼吸模式配置
struct BreathingPattern: Codable {
    let name: String
    let inhaleSeconds: Double
    let holdSeconds: Double
    let exhaleSeconds: Double
    let pauseSeconds: Double
    let description: String
    
    static let patterns: [BreathingPattern] = [
        BreathingPattern(
            name: "4-7-8 呼吸法",
            inhaleSeconds: 4,
            holdSeconds: 7,
            exhaleSeconds: 8,
            pauseSeconds: 0,
            description: "適合放鬆和入睡"
        ),
        BreathingPattern(
            name: "箱式呼吸",
            inhaleSeconds: 4,
            holdSeconds: 4,
            exhaleSeconds: 4,
            pauseSeconds: 4,
            description: "平衡身心，提升專注力"
        ),
        BreathingPattern(
            name: "深度放鬆",
            inhaleSeconds: 6,
            holdSeconds: 2,
            exhaleSeconds: 8,
            pauseSeconds: 2,
            description: "深度放鬆，釋放壓力"
        )
    ]
}

// MARK: - 放鬆提示
struct RelaxationTip: Codable {
    let title: String
    let content: String
    let mode: RelaxationMode
    let timeRange: ClosedRange<Int> // 在第幾分鐘顯示
    
    // 手動實現 Codable 因為 ClosedRange 需要特殊處理
    private enum CodingKeys: String, CodingKey {
        case title, content, mode, timeRangeStart, timeRangeEnd
    }
    
    init(title: String, content: String, mode: RelaxationMode, timeRange: ClosedRange<Int>) {
        self.title = title
        self.content = content
        self.mode = mode
        self.timeRange = timeRange
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        mode = try container.decode(RelaxationMode.self, forKey: .mode)
        let start = try container.decode(Int.self, forKey: .timeRangeStart)
        let end = try container.decode(Int.self, forKey: .timeRangeEnd)
        timeRange = start...end
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(mode, forKey: .mode)
        try container.encode(timeRange.lowerBound, forKey: .timeRangeStart)
        try container.encode(timeRange.upperBound, forKey: .timeRangeEnd)
    }
    
    static let tips: [RelaxationTip] = [
        // 呼吸模式提示
        RelaxationTip(
            title: "保持自然",
            content: "不要強迫呼吸，讓它自然流動",
            mode: .breathing,
            timeRange: 2...3
        ),
        RelaxationTip(
            title: "放鬆肩膀",
            content: "注意放鬆肩膀和頸部的緊張",
            mode: .breathing,
            timeRange: 5...7
        ),
        RelaxationTip(
            title: "專注當下",
            content: "將注意力帶回到呼吸上",
            mode: .breathing,
            timeRange: 10...12
        ),
        
        // 冥想模式提示
        RelaxationTip(
            title: "觀察思緒",
            content: "注意到思緒時，溫和地將注意力帶回",
            mode: .meditation,
            timeRange: 3...5
        ),
        RelaxationTip(
            title: "身體掃描",
            content: "感受身體各部位的感覺",
            mode: .meditation,
            timeRange: 8...10
        ),
        RelaxationTip(
            title: "保持覺察",
            content: "保持對當下體驗的覺察",
            mode: .meditation,
            timeRange: 15...18
        )
    ]
}

// MARK: - HRV 數據點
struct HRVDataPoint: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let value: Double
    let quality: HRVQuality
    
    init(id: UUID = UUID(), timestamp: Date = Date(), value: Double, quality: HRVQuality) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
        self.quality = quality
    }
    
    enum HRVQuality: String, Codable {
        case poor = "poor"
        case fair = "fair"
        case good = "good"
        case excellent = "excellent"
        
        var color: Color {
            switch self {
            case .poor: return .moodAngry
            case .fair: return .orange
            case .good: return .yellow
            case .excellent: return .moodCalm
            }
        }
        
        var description: String {
            switch self {
            case .poor: return "較低"
            case .fair: return "一般"
            case .good: return "良好"
            case .excellent: return "優秀"
            }
        }
        
        static func fromString(_ string: String) -> HRVQuality {
            switch string {
            case "較低": return .poor
            case "一般": return .fair
            case "良好": return .good
            case "優秀": return .excellent
            default: return .fair
            }
        }
    }
}

// MARK: - 放鬆會話記錄
struct RelaxationSession: Identifiable, Codable {
    let id: UUID
    let mode: RelaxationMode
    let duration: TimeInterval
    let completedAt: Date
    let pattern: String? // 呼吸模式名稱
    let averageHRV: Double?
    let notes: String?
    
    init(id: UUID = UUID(), mode: RelaxationMode, duration: TimeInterval, completedAt: Date = Date(), pattern: String? = nil, averageHRV: Double? = nil, notes: String? = nil) {
        self.id = id
        self.mode = mode
        self.duration = duration
        self.completedAt = completedAt
        self.pattern = pattern
        self.averageHRV = averageHRV
        self.notes = notes
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - 計時器配置
struct TimerConfiguration {
    let totalMinutes: Int
    let mode: RelaxationMode
    let breathingPattern: BreathingPattern?
    
    var totalSeconds: TimeInterval {
        return TimeInterval(totalMinutes * 60)
    }
    
    static let availableDurations = [5, 10, 15, 20, 25, 30]
}
