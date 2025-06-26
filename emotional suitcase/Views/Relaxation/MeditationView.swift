import SwiftUI

struct MeditationView: View {
    let configuration: TimerConfiguration
    
    @StateObject private var timerManager = TimerManager()
    @StateObject private var hrvManager = HRVManager.shared
    
    @State private var showingTip = false
    @State private var currentTip: RelaxationTip?
    @State private var pulseScale: CGFloat = 1.0
    @State private var showingMusicSelector = false
    @State private var selectedMusic: MeditationMusic = .none
    @State private var showHRV = false  // 預設不顯示，需要手動連接和開啟
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(AppColors.backgroundLight),
                    Color(AppColors.orangeMain).opacity(0.2)
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
                            .foregroundColor(AppColors.grayTextText)
                            .padding(12)
                            .background(Circle().fill(AppColors.white.opacity(0.8)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("冥想練習")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.brownDeep)
                        
                        Text("專注當下，放鬆身心")
                            .font(.caption)
                            .foregroundColor(AppColors.grayTextText)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        // 音樂選擇按鈕
                        Button(action: {
                            showingMusicSelector = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: selectedMusic == .none ? "speaker.slash" : "speaker.wave.2")
                                    .font(.title3)
                                
                                if selectedMusic != .none {
                                    Text(selectedMusic.displayName)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                            .foregroundColor(AppColors.grayTextText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.white.opacity(0.8))
                            )
                        }
                        
                        // 播放/暫停按鈕
                        Button(action: {
                            if timerManager.timerState == .running {
                                timerManager.pauseTimer()
                            } else if timerManager.timerState == .paused {
                                timerManager.resumeTimer()
                            }
                        }) {
                            Image(systemName: timerManager.timerState == .running ? "pause" : "play")
                                .font(.title3)
                                .foregroundColor(AppColors.grayTextText)
                                .padding(12)
                                .background(Circle().fill(AppColors.white.opacity(0.8)))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(AppColors.white)
                
                Spacer()
                
                // 冥想引導區域
                VStack(spacing: 40) {
                    // 時間顯示
                    Text(timerManager.formattedTimeRemaining)
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .foregroundColor(AppColors.brownDeep)
                        .monospacedDigit()
                    
                    // 冥想視覺元素
                    ZStack {
                        // 外圈脈動效果
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    Color(AppColors.orangeMain).opacity(0.3 - Double(index) * 0.1),
                                    lineWidth: 2
                                )
                                .frame(width: 200 + CGFloat(index) * 40, height: 200 + CGFloat(index) * 40)
                                .scaleEffect(pulseScale)
                                .animation(
                                    Animation.easeInOut(duration: 3.0 + Double(index) * 0.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.3),
                                    value: pulseScale
                                )
                        }
                        
                        // 中心圓
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.white,
                                        Color(AppColors.orangeMain).opacity(0.3)
                                    ]),
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .shadow(color: Color(AppColors.orangeMain).opacity(0.3), radius: 20)
                        
                        // 中心圖標
                        Image(systemName: "leaf")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.orangeMain)
                    }
                    
                    // 引導文字（固定高度避免重疊）
                    VStack(spacing: 16) {
                        Text(getCurrentGuidanceText())
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.brownDeep)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(height: 60)
                        
                        // 進度條
                        ProgressView(value: timerManager.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: AppColors.orangeMain))
                            .frame(width: 200)
                    }
                }
                
                Spacer()
                
                // HRV 區域（只有連接且開啟顯示才顯示）
                if showHRV && hrvManager.isConnected {
                    VStack(spacing: 12) {
                        HStack {
                            Text("心率變異性")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.grayTextText)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showHRV = false
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.caption)
                                    .foregroundColor(AppColors.grayTextText)
                            }
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(hrvManager.hrvTrend.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(hrvManager.hrvTrend.description)
                                    .font(.caption)
                                    .foregroundColor(AppColors.grayTextText)
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
                HStack(spacing: 40) {
                    if showHRV && hrvManager.isConnected {
                        VStack(spacing: 4) {
                            Text("平均HRV")
                                .font(.caption)
                                .foregroundColor(AppColors.grayTextText)
                            Text(String(format: "%.1f", hrvManager.averageHRV))
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.brownDeep)
                        }
                    }
                    
                    VStack(spacing: 4) {
                        Text("冥想時間")
                            .font(.caption)
                            .foregroundColor(AppColors.grayTextText)
                        Text(formatElapsedTime())
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.brownDeep)
                    }
                    
                    VStack(spacing: 4) {
                        Text("完成度")
                            .font(.caption)
                            .foregroundColor(AppColors.grayTextText)
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
                            .foregroundColor(AppColors.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(AppColors.orangeMain))
                                    .shadow(color: Color(AppColors.orangeMain).opacity(0.4), radius: 8, x: 0, y: 4)
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
                            .foregroundColor(AppColors.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(showHRV ? Color(AppColors.moodCalm) : Color(AppColors.orangeMain))
                                    .shadow(color: (showHRV ? Color(AppColors.moodCalm) : Color(AppColors.orangeMain)).opacity(0.4), radius: 8, x: 0, y: 4)
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
        .sheet(isPresented: $showingMusicSelector) {
            MusicSelectorView(selectedMusic: $selectedMusic)
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
        timerManager.configure(totalTime: configuration.totalSeconds)
        timerManager.startTimer()
        
        // 開始脈動動畫
        pulseScale = 1.2
    }
    
    private func getCurrentGuidanceText() -> String {
        let progressPercentage = Int(timerManager.progress * 100)
        
        switch progressPercentage {
        case 0..<10:
            return "找到舒適的姿勢，輕輕閉上雙眼"
        case 10..<25:
            return "注意您的呼吸，感受氣息的自然流動"
        case 25..<50:
            return "當思緒浮現時，溫和地將注意力帶回呼吸"
        case 50..<75:
            return "保持覺察，觀察身體的感受"
        case 75..<90:
            return "繼續專注，享受這份寧靜"
        default:
            return "準備結束，慢慢回到當下"
        }
    }
    
    private func formatElapsedTime() -> String {
        let elapsed = configuration.totalSeconds - timerManager.timeRemaining
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func checkForTips(at minutes: Int) {
        let availableTips = RelaxationTip.tips.filter { tip in
            tip.mode == .meditation && tip.timeRange.contains(minutes)
        }
        
        if let tip = availableTips.randomElement(), !showingTip {
            currentTip = tip
            showingTip = true
        }
    }
    
    private func completeSession() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - 冥想音樂
enum MeditationMusic: String, CaseIterable {
    case none = "none"
    case rain = "rain"
    case forest = "forest"
    case ocean = "ocean"
    case whitenoise = "whitenoise"
    
    var displayName: String {
        switch self {
        case .none: return "無音樂"
        case .rain: return "雨聲"
        case .forest: return "森林"
        case .ocean: return "海浪"
        case .whitenoise: return "白噪音"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "speaker.slash"
        case .rain: return "cloud.rain"
        case .forest: return "tree"
        case .ocean: return "waveform"
        case .whitenoise: return "speaker.wave.3"
        }
    }
}

// MARK: - 音樂選擇器
struct MusicSelectorView: View {
    @Binding var selectedMusic: MeditationMusic
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("選擇背景音樂")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                    .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach(MeditationMusic.allCases, id: \.self) { music in
                        Button(action: {
                            selectedMusic = music
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: music.icon)
                                    .font(.title2)
                                    .foregroundColor(AppColors.orangeMain)
                                    .frame(width: 40)
                                
                                Text(music.displayName)
                                    .font(.headline)
                                    .foregroundColor(AppColors.brownDeep)
                                
                                Spacer()
                                
                                if selectedMusic == music {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(AppColors.orangeMain)
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                selectedMusic == music ? AppColors.orangeMain : AppColors.grayTextText.opacity(0.3),
                                                lineWidth: selectedMusic == music ? 2 : 1
                                            )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(AppColors.backgroundLight)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    MeditationView(
        configuration: TimerConfiguration(
            totalMinutes: 10,
            mode: .meditation,
            breathingPattern: nil
        )
    )
}
