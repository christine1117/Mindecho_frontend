import Foundation

struct DailyCheckInScores: Codable, Identifiable {
    let id: UUID = UUID()
    var physical: Int
    var mental: Int
    var emotional: Int
    var sleep: Int
    var appetite: Int
    var date: Date
} 