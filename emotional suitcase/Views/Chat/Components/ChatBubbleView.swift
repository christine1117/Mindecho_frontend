import SwiftUI

// MARK: - 聊天氣泡
struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColors.orangeMain)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.grayText)
                }
            } else {
                HStack(alignment: .top, spacing: 8) {
                    // AI 模式圖標
                    ZStack {
                        Circle()
                            .fill(message.mode.color.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Text(message.mode.shortName)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(message.mode.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.content)
                            .font(.subheadline)
                            .foregroundColor(AppColors.brownDeep)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                        
                        Text(formatTime(message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.grayText)
                            .padding(.leading, 4)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - 圓角擴展
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VStack(spacing: 20) {
        ChatBubbleView(message: ChatMessage(
            content: "這是一條測試訊息",
            isFromUser: true,
            mode: .chatMode
        ))
        
        ChatBubbleView(message: ChatMessage(
            content: "這是AI的回覆訊息，內容比較長一些，用來測試氣泡的顯示效果。",
            isFromUser: false,
            mode: .cbtMode
        ))
    }
    .padding()
    .background(AppColors.backgroundLight)
}
