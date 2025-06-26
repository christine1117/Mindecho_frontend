import SwiftUI

struct RelaxationTipsView: View {
    let tip: RelaxationTip
    @Binding var isShowing: Bool
    
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 20
    
    var body: some View {
        VStack {
            Spacer()
            
            // 底部溫和提示條
            HStack(spacing: 12) {
                // 小圖標
                Image(systemName: tip.mode == .breathing ? "wind" : "leaf")
                    .font(.caption)
                    .foregroundColor(tip.mode.color)
                    .frame(width: 16, height: 16)
                
                // 提示內容
                VStack(alignment: .leading, spacing: 2) {
                    Text(tip.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(tip.content)
                        .font(.caption2)
                        .foregroundColor(.grayText)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // 可選的關閉按鈕（很小，不顯眼）
                Button(action: {
                    dismissTip()
                }) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundColor(.grayText.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(tip.mode.color.opacity(0.3), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 140) // 避免與底部統計資訊重疊
            .offset(y: offset)
            .opacity(opacity)
        }
        .onAppear {
            showTip()
            
            // 溫和地自動消失（8秒後，給用戶更多時間閱讀）
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                if isShowing {
                    dismissTip()
                }
            }
        }
    }
    
    private func showTip() {
        withAnimation(.easeOut(duration: 0.6)) {
            opacity = 1.0
            offset = 0
        }
    }
    
    private func dismissTip() {
        withAnimation(.easeIn(duration: 0.4)) {
            opacity = 0.0
            offset = 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isShowing = false
        }
    }
}

#Preview {
    ZStack {
        AppColors.backgroundLight
            .ignoresSafeArea()
        
        RelaxationTipsView(
            tip: RelaxationTip(
                title: "保持自然",
                content: "不要強迫呼吸，讓它自然流動",
                mode: .breathing,
                timeRange: 2...3
            ),
            isShowing: .constant(true)
        )
    }
}
