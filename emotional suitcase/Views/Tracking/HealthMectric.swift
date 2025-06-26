import Foundation
import SwiftUI

enum HealthMetricType: String, CaseIterable, Codable {
    case heartRateVariability = "心率變異性"
    case sleepQuality = "睡眠質量"
    case activityLevel = "活動量"
    case weight = "體重"
    
    var unit: String {
        switch self {
        case .heartRateVariability: return "ms"
        case .sleepQuality: return "小時"
        case .activityLevel: return "步"
        case .weight: return "公斤"
        }
    }
    
    var icon: String {
        switch self {
        case .heartRateVariability: return "heart.fill"
        case .sleepQuality: return "moon.fill"
        case .activityLevel: return "figure.walk"
        case .weight: return "scalemass.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .heartRateVariability: return .moodAngry
        case .sleepQuality: return .blue
        case .activityLevel: return .moodCalm
        case .weight: return .purple
        }
    }
}

struct HealthMetric: Identifiable, Codable {
    let id = UUID()
    let type: HealthMetricType
    var value: Double
    var lastUpdated: Date
    var trend: Double?
    
    init(type: HealthMetricType, value: Double, trend: Double? = nil) {
        self.type = type
        self.value = value
        self.trend = trend
        self.lastUpdated = Date()
    }
    
    var formattedValue: String {
        switch type {
        case .heartRateVariability:
            return String(format: "%.0f", value)
        case .sleepQuality:
            return String(format: "%.1f", value)
        case .activityLevel:
            return String(format: "%.0f", value)
        case .weight:
            return String(format: "%.1f", value)
        }
    }
}
