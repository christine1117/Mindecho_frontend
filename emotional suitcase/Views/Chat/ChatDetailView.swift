import SwiftUI

struct ChatDetailView: View {
    let session: ChatSession
    @ObservedObject private var chatManager = ChatManager.shared
    @State private var messageText = ""
    @State private var selectedMode: TherapyMode
    @State private var isTyping = false
    @State private var showingModeChangeConfirmation = false
    @State private var targetMode: TherapyMode?
    @State private var showingClearChatAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    init(session: ChatSession) {
        self.session = session
        self._selectedMode = State(initialValue: session.therapyMode)
    }
    
    private var messages: [ChatMessage] {
        chatManager.getMessages(for: session.id)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 標題欄
            ChatHeaderView(
                session: session,
                selectedMode: $selectedMode,
                onModeChange: { newMode in
                    if newMode != selectedMode {
                        targetMode = newMode
                        showingModeChangeConfirmation = true
                    }
                },
                onBack: {
                    presentationMode.wrappedValue.dismiss()
                },
                onClearChat: {
                    showingClearChatAlert = true
                }
            )
            
            // 聊天消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            ChatBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        // 打字指示器
                        if isTyping {
                            HStack {
                                HStack(alignment: .top, spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedMode.color.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Text(selectedMode.shortName)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(selectedMode.color)
                                    }
                                    
                                    TypingIndicatorView()
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .onChange(of: messages.count) { _ in
                    // 自動滾動到最新消息
                    if let lastMessage = messages.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isTyping) { typing in
                    if typing {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }
            
            // 輸入框
            ChatInputView(
                messageText: $messageText,
                onSend: sendMessage,
                mode: selectedMode
            )
        }
        .background(AppColors.backgroundLight)
        .navigationBarHidden(true)
        .overlay(
            // 模式切換確認對話框
            Group {
                if showingModeChangeConfirmation, let target = targetMode {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showingModeChangeConfirmation = false
                                targetMode = nil
                            }
                        
                        ModeChangeConfirmationView(
                            currentMode: selectedMode,
                            targetMode: target,
                            onConfirm: {
                                selectedMode = target
                                chatManager.updateSessionMode(session.id, mode: target)
                                showingModeChangeConfirmation = false
                                targetMode = nil
                            },
                            onCancel: {
                                showingModeChangeConfirmation = false
                                targetMode = nil
                            }
                        )
                        .padding(.horizontal, 32)
                    }
                }
            }
        )
        .alert("清除對話", isPresented: $showingClearChatAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                clearCurrentChat()
            }
        } message: {
            Text("確定要清除當前對話的所有訊息嗎？此操作無法復原。")
        }
    }
    
    private func clearCurrentChat() {
        chatManager.clearMessages(for: session.id)
        // 重新添加歡迎訊息
        chatManager.addWelcomeMessage(to: session.id, mode: selectedMode)
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        // 添加用戶消息
        chatManager.addMessage(to: session.id, content: trimmedMessage, isFromUser: true)
        
        // 清空輸入框
        messageText = ""
        
        // 顯示打字指示器
        isTyping = true
        
        // 模擬AI回覆延遲
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            
            // 生成AI回覆
            let aiResponse = chatManager.generateAIResponse(for: trimmedMessage, mode: selectedMode)
            chatManager.addMessage(to: session.id, content: aiResponse, isFromUser: false)
        }
    }
}

// MARK: - 聊天標題欄
struct ChatHeaderView: View {
    let session: ChatSession
    @Binding var selectedMode: TherapyMode
    let onModeChange: (TherapyMode) -> Void
    let onBack: () -> Void
    let onClearChat: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // 頂部導航欄
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Text("返回")
                            .font(.subheadline)
                    }
                    .foregroundColor(AppColors.orangeMain)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text(session.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.brownDeep)
                        .lineLimit(1)
                    
                    Text("最後活動: \(formatRelativeTime(session.lastUpdated))")
                        .font(.caption)
                        .foregroundColor(AppColors.grayTextText)
                }
                
                Spacer()
                
                // 會話選項按鈕
                Menu {
                    Button(action: {
                        // TODO: 分享功能
                    }) {
                        Label("分享對話", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(action: {
                        // TODO: 匯出功能
                    }) {
                        Label("匯出對話", systemImage: "doc.text")
                    }
                    
                    Divider()
                    
                    Button(action: {
                        onClearChat()
                    }) {
                        Label("清除對話", systemImage: "trash")
                    }
                    .foregroundColor(AppColors.moodAngry)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundColor(.grayText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // 模式選擇器
            HStack(spacing: 8) {
                ForEach(TherapyMode.allCases, id: \.self) { mode in
                    Button(action: {
                        if selectedMode != mode {
                            onModeChange(mode)
                        }
                    }) {
                        Text(mode.shortName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedMode == mode ? .white : mode.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedMode == mode ? mode.color : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(mode.color, lineWidth: 1)
                                    )
                            )
                    }
                    .scaleEffect(selectedMode == mode ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: selectedMode)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "剛剛"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)分鐘前"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)小時前"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M月d日"
            formatter.locale = Locale(identifier: "zh_Hant_TW")
            return formatter.string(from: date)
        }
    }
}

// MARK: - 打字指示器
struct TypingIndicatorView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.grayText)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animationOffset == CGFloat(index) ? 1.2 : 0.8)
                    .opacity(animationOffset == CGFloat(index) ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animationOffset
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
        .onAppear {
            withAnimation {
                animationOffset = 2
            }
        }
    }
}

#Preview {
    NavigationView {
        ChatDetailView(session: ChatSession(
            title: "測試對話",
            therapyMode: .chatMode,
            lastMessage: "最後一條消息",
            tags: ["測試"]
        ))
    }
}
