import Foundation
import SwiftUI

final class ChatManager: ObservableObject {
    static let shared = ChatManager()
    
    @Published var sessions: [ChatSession] = []
    @Published var currentSession: ChatSession?
    
    private init() {
        loadSampleData()
    }
    
    // MARK: - 聊天會話管理
    func createSession(mode: TherapyMode) -> ChatSession {
        let session = ChatSession(
            id: UUID(),
            title: "新會話",
            therapyMode: mode,
            lastMessage: "",
            lastUpdated: Date(),
            tags: [],
            messageCount: 0,
            mode: mode,
            createdAt: Date(),
            messages: []
        )
        sessions.append(session)
        currentSession = session
        return session
    }
    
    func getSession(by id: UUID) -> ChatSession? {
        return sessions.first { $0.id == id }
    }
    
    func updateSession(_ session: ChatSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        }
    }
    
    // MARK: - 訊息管理
    func addMessage(to sessionId: UUID, content: String, isFromUser: Bool) {
        guard let sessionIndex = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        
        let message = ChatMessage(
            id: UUID(),
            content: content,
            isFromUser: isFromUser,
            timestamp: Date(),
            mode: sessions[sessionIndex].mode
        )
        
        sessions[sessionIndex].messages.append(message)
        
        // 如果是使用者訊息，自動產生 AI 回覆
        if isFromUser {
            generateAIResponse(for: sessionId, userMessage: content)
        }
    }
    
    func clearMessages(for sessionId: UUID) {
        guard let sessionIndex = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        sessions[sessionIndex].messages.removeAll()
    }
    
    // MARK: - AI 回覆生成
    private func generateAIResponse(for sessionId: UUID, userMessage: String) {
        guard let session = getSession(by: sessionId) else { return }
        
        // 模擬 AI 回覆
        let aiResponse = generateMockAIResponse(for: userMessage, mode: session.mode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addMessage(to: sessionId, content: aiResponse, isFromUser: false)
        }
    }
    
    private func generateMockAIResponse(for message: String, mode: TherapyMode) -> String {
        switch mode {
        case .chatMode:
            return "我理解你的感受。讓我們一起聊聊這個話題。"
        case .cbtMode:
            return "讓我們用認知行為療法的方式來分析這個想法。"
        case .mbtMode:
            return "讓我們用正念的方式來觀察這個感受。"
        }
    }
    
    // MARK: - 歡迎訊息
    func addWelcomeMessage(to sessionId: UUID, mode: TherapyMode) {
        let welcomeMessage = mode.welcomeMessage
        addMessage(to: sessionId, content: welcomeMessage, isFromUser: false)
    }
    
    // MARK: - 模式切換
    func updateSessionMode(_ sessionId: UUID, mode: TherapyMode) {
        guard let sessionIndex = sessions.firstIndex(where: { $0.id == sessionId }) else { return }
        sessions[sessionIndex].mode = mode
    }
    
    // MARK: - 範例資料
    private func loadSampleData() {
        let sampleSession = ChatSession(
            id: UUID(),
            title: "新會話",
            therapyMode: .chatMode,
            lastMessage: "",
            lastUpdated: Date(),
            tags: [],
            messageCount: 0,
            mode: .chatMode,
            createdAt: Date(),
            messages: [
                ChatMessage(id: UUID(), content: "你好！", isFromUser: false, timestamp: Date(), mode: .chatMode),
                ChatMessage(id: UUID(), content: "我想聊聊今天的心情", isFromUser: true, timestamp: Date(), mode: .chatMode)
            ]
        )
        sessions.append(sampleSession)
    }
} 