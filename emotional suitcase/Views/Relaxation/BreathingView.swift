import SwiftUI

struct BreathingView: View {
    let configuration: TimerConfiguration
    
    @StateObject private var timerManager = TimerManager()
    @StateObject private var breathingManager = BreathingManager()
    @StateObject private var hrvManager = HRVManager.shared
    
    @State private var showingTip = false
    @State private var currentTip: RelaxationTip?
    @State private var showHRV = false  // 預設不顯示，需要手動連接
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundLight,
                    breathingManager.currentPhase.color.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 頂部控制欄 - 白底
                HStack {
                    Button(action: {
                        timerManager.stopTimer()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.grayText)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("呼吸練習")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.brownDeep)
                        
                        Text(breathingManager.pattern.name)
                            .font(.caption)
                            .foregroundColor(.grayText)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if timerManager.timerState == .running {
                            timerManager.pauseTimer()
                        } else if timerManager.timerState == .paused {
                            timerManager.resumeTimer()
                        }
                    }) {
                        Image(systemName: timerManager.timerState == .running ? "pause" : "play")
                            .font(.title3)
                            .foregroundColor(.grayText)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                
                Spacer()
                
                // 呼吸引導區域
                VStack(spacing: 40) {
                    // 時間顯示
                    Text(timerManager.formattedTimeRemaining)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.brownDeep)
                    
                    // 呼吸引導圓圈
                    BreathingGuideView(
                        phase: breathingManager.currentPhase,
                        progress: breathingManager.phaseProgress,
                        scale: breathingManager.circleScale
                    )
                    
                    // 階段指示
                    VStack(spacing: 8) {
                        Text(breathingManager.currentPhase.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(breathingManager.currentPhase.color)
                        
                        Text(breathingManager.currentPhase.instruction)
                            .font(.subheadline)
                            .foregroundColor(.grayText)
                        
                        // 階段倒計時
                        Text(String(format: "%.0f", breathingManager.phaseTimeRemaining))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(breathingManager.currentPhase.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(breathingManager.currentPhase.color.opacity(0.2))
                            )
                    }
                }
                
                Spacer()
                
                // HRV 圖表區域（只有連接且開啟顯示才顯示）
                if showHRV && hrvManager.isConnected {
                    VStack(spacing: 12) {
                        HStack {
                            Text("心率變異性")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.grayText)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showHRV = false
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.caption)
                                    .foregroundColor(.grayText)
                            }
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(hrvManager.hrvTrend.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(hrvManager.hrvTrend.description)
                                    .font(.caption)
                                    .foregroundColor(.grayText)
                            }
                        }
                        
                        HRVChartView()
                            .frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                // 底部統計信息
                HStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text("呼吸週期")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        Text("\(breathingManager.completedCycles)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.brownDeep)
                    }
                    
                    if showHRV && hrvManager.isConnected {
                        VStack(spacing: 4) {
                            Text("當前HRV")
                                .font(.caption)
                                .foregroundColor(.grayText)
                            Text(String(format: "%.1f", hrvManager.currentHRV))
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.brownDeep)
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text("進度")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        Text(String(format: "%.0f%%", timerManager.progress * 100))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.brownDeep)
                    }
                }
                .padding(.bottom, 100) // 給右下角按鈕留空間
            }
        }
        .overlay(
            // HRV 連接/顯示按鈕（右下角）
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    if !hrvManager.isConnected {
                        // 未連接 - 顯示連接按鈕
                        Button(action: {
                            withAnimation(.spring()) {
                                hrvManager.connectDevice()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "heart.circle")
                                    .font(.title3)
                                
                                Text("連接HRV")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(AppColors.orangeMain)
                                    .shadow(color: AppColors.orangeMain.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // 已連接 - 顯示開啟/關閉 HRV 顯示按鈕
                        Button(action: {
                            withAnimation(.spring()) {
                                showHRV.toggle()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: showHRV ? "heart.circle.fill" : "heart.circle")
                                    .font(.title3)
                                
                                Text(showHRV ? "隱藏HRV" : "顯示HRV")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(showHRV ? Color.moodCalm : AppColors.orangeMain)
                                    .shadow(color: (showHRV ? Color.moodCalm : AppColors.orangeMain).opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        )
        .overlay(
            // 提示彈窗
            tipOverlay
        )
        .onAppear {
            setupSession()
        }
        .onChange(of: timerManager.elapsedMinutes) { oldValue, newValue in
            checkForTips(at: newValue)
        }
        .onReceive(timerManager.$timerState) { state in
            if state == .completed {
                completeSession()
            }
        }
    }
    
    private var tipOverlay: some View {
        Group {
            if showingTip, let tip = currentTip {
                RelaxationTipsView(
                    tip: tip,
                    isShowing: $showingTip
                )
            }
        }
    }
    
    private func setupSession() {
        if let pattern = configuration.breathingPattern {
            breathingManager.setPattern(pattern)
        }
        timerManager.configure(totalTime: configuration.totalSeconds)
        timerManager.startTimer()
        breathingManager.startBreathing()
    }
    
    private func checkForTips(at minutes: Int) {
        let availableTips = RelaxationTip.tips.filter { tip in
            tip.mode == .breathing && tip.timeRange.contains(minutes)
        }
        
        if let tip = availableTips.randomElement(), !showingTip {
            currentTip = tip
            showingTip = true
        }
    }
    
    private func completeSession() {
        breathingManager.stopBreathing()
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    BreathingView(
        configuration: TimerConfiguration(
            totalMinutes: 5,
            mode: .breathing,
            breathingPattern: BreathingPattern.patterns[0]
        )
    )
}
