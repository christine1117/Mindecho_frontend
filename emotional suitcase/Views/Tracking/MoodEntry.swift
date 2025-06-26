// Models/MoodEntry.swift
import Foundation
import SwiftUI  // 添加這個 import

enum MoodType: String, CaseIterable, Codable {
    case terrible = "很差"
    case bad = "不好"
    case neutral = "一般"
    case good = "良好"
    case excellent = "極佳"
    
    var emoji: String {
        switch self {
        case .terrible: return "😞"
        case .bad: return "😕"
        case .neutral: return "😐"
        case .good: return "😊"
        case .excellent: return "😄"
        }
    }
    
    var color: Color {  // 現在 Color 類型可以正確識別
        switch self {
        case .terrible: return .moodAngry
        case .bad: return .orange
        case .neutral: return .yellow
        case .good: return .moodCalm
        case .excellent: return .blue
        }
    }
    
    var score: Int {
        switch self {
        case .terrible: return 1
        case .bad: return 2
        case .neutral: return 3
        case .good: return 4
        case .excellent: return 5
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var mood: MoodType
    var note: String
    var createdAt: Date
    
    init(date: Date, mood: MoodType, note: String = "") {
        self.date = date
        self.mood = mood
        self.note = note
        self.createdAt = Date()
    }
}
