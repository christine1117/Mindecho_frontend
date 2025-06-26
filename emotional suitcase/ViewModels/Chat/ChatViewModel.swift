import Foundation
import emotional_suitcase/Models/ChatModels.swift
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var selectedMode: TherapyMode = TherapyMode.chatMode
    @Published var isTyping: Bool = false
    
    private let chatManager = ChatManager.shared
    
    // MARK: - 會話管理
    var sessions: [ChatSession] {
        chatManager.sessions
    }
    
    func createSession(mode: TherapyMode) -> ChatSession {
        return chatManager.createSession(mode: mode)
    }
    
    func getSession(by id: UUID) -> ChatSession? {
        return chatManager.getSession(by: id)
    }
    
    // MARK: - 訊息管理
    func getMessages(for sessionId: UUID) -> [ChatMessage] {
        return chatManager.getSession(by: sessionId)?.messages ?? []
    }
    
    func addMessage(to sessionId: UUID, content: String, isFromUser: Bool) {
        chatManager.addMessage(to: sessionId, content: content, isFromUser: isFromUser)
    }
    
    func clearMessages(for sessionId: UUID) {
        chatManager.clearMessages(for: sessionId)
    }
    
    func addWelcomeMessage(to sessionId: UUID, mode: TherapyMode) {
        chatManager.addWelcomeMessage(to: sessionId, mode: mode)
    }
    
    // MARK: - 模式管理
    func updateSessionMode(_ sessionId: UUID, mode: TherapyMode) {
        chatManager.updateSessionMode(sessionId, mode: mode)
    }
    
    // MARK: - AI 回覆
    func generateAIResponse(for message: String, mode: TherapyMode) -> String {
        // 這裡可以整合更複雜的 AI 邏輯
        switch mode {
        case .chatMode:
            return "我理解你的感受。讓我們一起聊聊這個話題。"
        case .cbtMode:
            return "讓我們用認知行為療法的方式來分析這個想法。"
        case .mbtMode:
            return "讓我們用正念的方式來觀察這個感受。"
        }
    }
    
    // MARK: - UI 狀態管理
    func setTypingStatus(_ isTyping: Bool) {
        self.isTyping = isTyping
    }
} 