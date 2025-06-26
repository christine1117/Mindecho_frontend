import SwiftUI

struct BreathingGuideView: View {
    let phase: BreathingPhase
    let progress: Double
    let scale: CGFloat
    
    var body: some View {
        ZStack {
            // 外層進度環
            Circle()
                .stroke(
                    Color.grayText.opacity(0.2),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 220, height: 220)
            
            // 進度環
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    phase.color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: progress)
            
            // 主要引導圓圈
            ZStack {
                // 光暈效果
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                phase.color.opacity(0.3),
                                phase.color.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .scaleEffect(scale)
                
                // 內層圓圈
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                phase.color.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                    .scaleEffect(scale)
                    .shadow(color: phase.color.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // 中心圖標或文字
                VStack(spacing: 8) {
                    Image(systemName: getPhaseIcon())
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(phase.color)
                    
                    Text(String(format: "%.0f", progress * getDurationForCurrentPhase()))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(phase.color.opacity(0.8))
                }
                .scaleEffect(scale)
            }
            
            // 粒子效果（吸氣時向內，呼氣時向外）
            if phase == .inhale || phase == .exhale {
                ParticleEffectView(
                    direction: phase == .inhale ? .inward : .outward,
                    color: phase.color
                )
            }
        }
    }
    
    private func getPhaseIcon() -> String {
        switch phase {
        case .inhale: return "arrow.down.circle"
        case .hold: return "pause.circle"
        case .exhale: return "arrow.up.circle"
        case .pause: return "circle"
        }
    }
    
    private func getDurationForCurrentPhase() -> Double {
        // 這裡應該從呼吸模式獲取，暫時使用默認值
        switch phase {
        case .inhale: return 4.0
        case .hold: return 7.0
        case .exhale: return 8.0
        case .pause: return 0.0
        }
    }
}

// MARK: - 粒子效果視圖
struct ParticleEffectView: View {
    enum Direction {
        case inward, outward
    }
    
    let direction: Direction
    let color: Color
    
    @State private var animationProgress: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                Circle()
                    .fill(color.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(
                        x: cos(Double(index) * .pi / 6) * (direction == .inward ? 120 - animationProgress * 60 : 60 + animationProgress * 60),
                        y: sin(Double(index) * .pi / 6) * (direction == .inward ? 120 - animationProgress * 60 : 60 + animationProgress * 60)
                    )
                    .opacity(1 - animationProgress)
                    .scaleEffect(1 - animationProgress * 0.5)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                animationProgress = 1.0
            }
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        BreathingGuideView(
            phase: .inhale,
            progress: 0.3,
            scale: 1.2
        )
        
        BreathingGuideView(
            phase: .exhale,
            progress: 0.7,
            scale: 0.8
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.backgroundLight)
}
