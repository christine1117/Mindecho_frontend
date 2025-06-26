import SwiftUI

// MARK: - 治療模式選擇器
struct TherapyModeSelector: View {
    @Binding var selectedMode: TherapyMode
    let onModeChange: (TherapyMode) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(TherapyMode.allCases, id: \.self) { mode in
                Button(action: {
                    if selectedMode != mode {
                        selectedMode = mode
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
}

// MARK: - 治療模式卡片（用於新對話選擇）
struct TherapyModeCard: View {
    let mode: TherapyMode
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // 模式圖標
                ZStack {
                    Circle()
                        .fill(mode.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(mode.shortName)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(mode.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(mode.description)
                        .font(.subheadline)
                        .foregroundColor(.grayText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(mode.color)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? mode.color : Color.grayText.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 模式簡介視圖
struct ModeIntroductionView: View {
    let mode: TherapyMode
    
    var features: [String] {
        switch mode {
        case .chatMode:
            return [
                "輕鬆自然的對話方式",
                "適合日常心情分享",
                "友善溫暖的交流氛圍"
            ]
        case .cbtMode:
            return [
                "識別負面思維模式",
                "挑戰不合理的想法",
                "建立積極的認知習慣"
            ]
        case .mbtMode:
            return [
                "增強情感覺察能力",
                "改善人際關係理解",
                "提升心智化水平"
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(mode.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(mode.shortName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(mode.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(mode.description)
                        .font(.subheadline)
                        .foregroundColor(.grayText)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("特色功能：")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.brownDeep)
                
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(mode.color)
                            .frame(width: 6, height: 6)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.grayText)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4)
    }
}

// MARK: - 模式切換確認視圖
struct ModeChangeConfirmationView: View {
    let currentMode: TherapyMode
    let targetMode: TherapyMode
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                    .font(.system(size: 48))
                    .foregroundColor(targetMode.color)
                
                Text("切換對話模式")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                
                Text("您想要從 \(currentMode.displayName) 切換到 \(targetMode.displayName) 嗎？")
                    .font(.subheadline)
                    .foregroundColor(.grayText)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    // 當前模式
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(currentMode.color.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Text(currentMode.shortName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentMode.color)
                        }
                        
                        Text(currentMode.displayName)
                            .font(.caption)
                            .foregroundColor(.grayText)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                        .foregroundColor(.grayText)
                    
                    // 目標模式
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(targetMode.color.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Text(targetMode.shortName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(targetMode.color)
                        }
                        
                        Text(targetMode.displayName)
                            .font(.caption)
                            .foregroundColor(.grayText)
                    }
                }
                
                Text(targetMode.description)
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            
            HStack(spacing: 12) {
                Button("取消", action: onCancel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.grayText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.grayText.opacity(0.1))
                    .cornerRadius(8)
                
                Button("確認切換", action: onConfirm)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(targetMode.color)
                    .cornerRadius(8)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 10)
    }
}

#Preview {
    VStack(spacing: 20) {
        TherapyModeSelector(
            selectedMode: .constant(.chatMode),
            onModeChange: { _ in }
        )
        
        TherapyModeCard(
            mode: .cbtMode,
            isSelected: true,
            onSelect: {}
        )
        
        ModeIntroductionView(mode: .mbtMode)
        
        ModeChangeConfirmationView(
            currentMode: .chatMode,
            targetMode: .cbtMode,
            onConfirm: {},
            onCancel: {}
        )
    }
    .padding()
    .background(AppColors.backgroundLight)
}
