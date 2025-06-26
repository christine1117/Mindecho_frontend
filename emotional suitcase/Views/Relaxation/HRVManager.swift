import SwiftUI
import Foundation
import Combine

// MARK: - HRV 數據管理器
class HRVManager: ObservableObject {
    static let shared = HRVManager()
    
    @Published var currentHRV: Double = 0.0
    @Published var hrvData: [HRVDataPoint] = []
    @Published var isConnected: Bool = false
    @Published var deviceName: String = ""
    @Published var batteryLevel: Int = 0
    
    private var timer: Timer?
    private var sessionStartTime: Date?
    
    init() {
        // 模擬 HRV 設備連接狀態
        simulateDeviceConnection()
    }
    
    // MARK: - 設備連接
    func connectDevice() {
        isConnected = true
        deviceName = "HRV Monitor Pro"
        batteryLevel = 85
        startHRVMonitoring()
    }
    
    func disconnectDevice() {
        isConnected = false
        deviceName = ""
        batteryLevel = 0
        stopHRVMonitoring()
    }
    
    // MARK: - HRV 監測
    func startHRVMonitoring() {
        sessionStartTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateHRVReading()
        }
    }
    
    func stopHRVMonitoring() {
        timer?.invalidate()
        timer = nil
        sessionStartTime = nil
    }
    
    private func updateHRVReading() {
        // 模擬真實的 HRV 數據
        let baseHRV = 45.0
        let variation = Double.random(in: -10...15)
        let breathingBonus = isInBreathingSession ? Double.random(in: 5...20) : 0
        
        currentHRV = max(20, min(100, baseHRV + variation + breathingBonus))
        
        let dataPoint = HRVDataPoint(
            timestamp: Date(),
            value: currentHRV,
            quality: getHRVQuality(currentHRV)
        )
        
        hrvData.append(dataPoint)
        
        // 保持最近 300 個數據點（5分鐘）
        if hrvData.count > 300 {
            hrvData.removeFirst(hrvData.count - 300)
        }
    }
    
    private func getHRVQuality(_ value: Double) -> HRVDataPoint.HRVQuality {
        switch value {
        case 0..<30: return .poor
        case 30..<50: return .fair
        case 50..<70: return .good
        default: return .excellent
        }
    }
    
    // MARK: - 會話統計
    var averageHRV: Double {
        guard !hrvData.isEmpty else { return 0 }
        return hrvData.map { $0.value }.moodAngryuce(0, +) / Double(hrvData.count)
    }
    
    var hrvTrend: HRVTrend {
        guard hrvData.count >= 10 else { return .stable }
        
        let recent = Array(hrvData.suffix(10))
        let firstHalf = Array(recent.prefix(5))
        let secondHalf = Array(recent.suffix(5))
        
        let firstAvg = firstHalf.map { $0.value }.moodAngryuce(0, +) / 5
        let secondAvg = secondHalf.map { $0.value }.moodAngryuce(0, +) / 5
        
        let difference = secondAvg - firstAvg
        
        if difference > 5 {
            return .improving
        } else if difference < -5 {
            return .declining
        } else {
            return .stable
        }
    }
    
    // MARK: - 模擬設備連接
    private func simulateDeviceConnection() {
        // 20% 機率模擬設備已連接
        if Double.random(in: 0...1) < 0.2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.connectDevice()
            }
        }
    }
    
    // MARK: - 呼吸會話檢測
    private var isInBreathingSession: Bool {
        // 這裡可以通過其他管理器檢測是否在進行呼吸練習
        return true
    }
    
    // MARK: - 數據清理
    func clearSessionData() {
        hrvData.removeAll()
        currentHRV = 0.0
    }
    
    // MARK: - 導出數據
    func exportHRVData() -> Data? {
        let exportData = HRVExportData(
            sessionStart: sessionStartTime ?? Date(),
            sessionEnd: Date(),
            dataPoints: hrvData,
            averageHRV: averageHRV,
            trend: hrvTrend
        )
        
        return try? JSONEncoder().encode(exportData)
    }
}

// MARK: - HRV 趨勢
enum HRVTrend {
    case improving, stable, declining
    
    var description: String {
        switch self {
        case .improving: return "改善中"
        case .stable: return "穩定"
        case .declining: return "下降"
        }
    }
    
    var color: Color {
        switch self {
        case .improving: return .moodCalm
        case .stable: return .blue
        case .declining: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .improving: return "arrow.up.circle.fill"
        case .stable: return "minus.circle.fill"
        case .declining: return "arrow.down.circle.fill"
        }
    }
}

// MARK: - HRV 導出數據結構
struct HRVExportData: Codable {
    let sessionStart: Date
    let sessionEnd: Date
    let dataPoints: [HRVDataPoint]
    let averageHRV: Double
    let trend: String
    
    init(sessionStart: Date, sessionEnd: Date, dataPoints: [HRVDataPoint], averageHRV: Double, trend: HRVTrend) {
        self.sessionStart = sessionStart
        self.sessionEnd = sessionEnd
        self.dataPoints = dataPoints
        self.averageHRV = averageHRV
        self.trend = trend.description
    }
}

// 讓 HRVDataPoint 支援 Codable
extension HRVDataPoint {
    enum CodingKeys: String, CodingKey {
        case id, timestamp, value, quality
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        value = try container.decode(Double.self, forKey: .value)
        quality = try container.decode(HRVDataPoint.HRVQuality.self, forKey: .quality)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(value, forKey: .value)
        try container.encode(quality, forKey: .quality)
    }
}
