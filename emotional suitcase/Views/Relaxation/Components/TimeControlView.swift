import SwiftUI

struct TimerControlView: View {
    @ObservedObject var timerManager: TimerManager
    let configuration: TimerConfiguration
    let onComplete: () -> Void
    let onCancel: () -> Void
    
    @State private var showingCancelAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            // 時間顯示區域
            VStack(spacing: 16) {
                // 剩餘時間
                Text(timerManager.formattedTimeRemaining)
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .foregroundColor(AppColors.brownDeep)
                    .monospacedDigit()
                
                // 進度條
                VStack(spacing: 8) {
                    HStack {
                        Text("進度")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        
                        Spacer()
                        
                        Text("\(Int(timerManager.progress * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(configuration.mode.color)
                    }
                    
                    ProgressView(value: timerManager.progress)
                        .progressViewStyle(
                            LinearProgressViewStyle(tint: configuration.mode.color)
                        )
                        .frame(height: 8)
                        .background(Color.grayText.opacity(0.2))
                        .cornerRadius(4)
                }
                .padding(.horizontal, 20)
            }
            
            // 控制按鈕區域
            HStack(spacing: 32) {
                // 取消按鈕
                Button(action: {
                    if timerManager.timerState == .running {
                        showingCancelAlert = true
                    } else {
                        onCancel()
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.grayText)
                        
                        Text("取消")
                            .font(.caption)
                            .foregroundColor(.grayText)
                    }
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                Circle()
                                    .stroke(Color.grayText.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // 主控制按鈕（播放/暫停）
                Button(action: {
                    switch timerManager.timerState {
                    case .stopped:
                        timerManager.startTimer()
                    case .running:
                        timerManager.pauseTimer()
                    case .paused:
                        timerManager.resumeTimer()
                    case .completed:
                        onComplete()
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: getMainButtonIcon())
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text(getMainButtonText())
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80, height: 80)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        configuration.mode.color,
                                        configuration.mode.color.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: configuration.mode.color.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                }
                .scaleEffect(timerManager.timerState == .running ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: timerManager.timerState)
                
                // 重置按鈕
                Button(action: {
                    timerManager.resetTimer()
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundColor(configuration.mode.color)
                        
                        Text("重置")
                            .font(.caption)
                            .foregroundColor(configuration.mode.color)
                    }
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                Circle()
                                    .stroke(configuration.mode.color, lineWidth: 1)
                            )
                    )
                }
                .disabled(timerManager.timerState == .stopped)
                .opacity(timerManager.timerState == .stopped ? 0.5 : 1.0)
            }
            
            // 時間調整區域（僅在停止狀態顯示）
            if timerManager.timerState == .stopped {
                TimeAdjustmentView(
                    configuration: configuration,
                    onTimeChanged: { newTime in
                        timerManager.configure(totalTime: newTime)
                    }
                )
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .alert("確認取消", isPresented: $showingCancelAlert) {
            Button("繼續", role: .cancel) { }
            Button("取消練習", role: .destructive) {
                timerManager.stopTimer()
                onCancel()
            }
        } message: {
            Text("確定要取消當前的\(configuration.mode.displayName)練習嗎？")
        }
        .onReceive(timerManager.$timerState) { state in
            if state == .completed {
                onComplete()
            }
        }
    }
    
    private func getMainButtonIcon() -> String {
        switch timerManager.timerState {
        case .stopped: return "play.fill"
        case .running: return "pause.fill"
        case .paused: return "play.fill"
        case .completed: return "checkmark"
        }
    }
    
    private func getMainButtonText() -> String {
        switch timerManager.timerState {
        case .stopped: return "開始"
        case .running: return "暫停"
        case .paused: return "繼續"
        case .completed: return "完成"
        }
    }
}

// MARK: - 時間調整視圖
struct TimeAdjustmentView: View {
    let configuration: TimerConfiguration
    let onTimeChanged: (TimeInterval) -> Void
    
    @State private var selectedMinutes: Int
    
    init(configuration: TimerConfiguration, onTimeChanged: @escaping (TimeInterval) -> Void) {
        self.configuration = configuration
        self.onTimeChanged = onTimeChanged
        self._selectedMinutes = State(initialValue: configuration.totalMinutes)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("調整時間")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.grayText)
            
            HStack(spacing: 20) {
                // 減少時間
                Button(action: {
                    if selectedMinutes > 1 {
                        selectedMinutes -= 1
                        onTimeChanged(TimeInterval(selectedMinutes * 60))
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(configuration.mode.color)
                }
                .disabled(selectedMinutes <= 1)
                
                // 時間顯示
                VStack(spacing: 4) {
                    Text("\(selectedMinutes)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(configuration.mode.color)
                        .monospacedDigit()
                    
                    Text("分鐘")
                        .font(.caption)
                        .foregroundColor(.grayText)
                }
                .frame(width: 80)
                
                // 增加時間
                Button(action: {
                    if selectedMinutes < 60 {
                        selectedMinutes += 1
                        onTimeChanged(TimeInterval(selectedMinutes * 60))
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(configuration.mode.color)
                }
                .disabled(selectedMinutes >= 60)
            }
            
            // 快速選擇按鈕
            HStack(spacing: 12) {
                ForEach([5, 10, 15, 20, 25, 30], id: \.self) { minutes in
                    Button(action: {
                        selectedMinutes = minutes
                        onTimeChanged(TimeInterval(minutes * 60))
                    }) {
                        Text("\(minutes)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(selectedMinutes == minutes ? .white : configuration.mode.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(selectedMinutes == minutes ? configuration.mode.color : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(configuration.mode.color, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.grayText.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        TimerControlView(
            timerManager: TimerManager(),
            configuration: TimerConfiguration(
                totalMinutes: 10,
                mode: .breathing,
                breathingPattern: nil
            ),
            onComplete: {},
            onCancel: {}
        )
        .padding()
    }
    .background(AppColors.backgroundLight)
}
