import SwiftUI

struct RelaxationView: View {
    @State private var selectedMode: RelaxationMode = .meditation
    @State private var selectedDuration: Int = 25
    @State private var showingSession = false
    @StateObject private var hrvManager = HRVManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 標題區域 - 白底，確保文字完全置中
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.orangeMain)
                        }
                        .frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("放鬆")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.brownDeep)
                            
                            Text("遠離喧囂與呼吸，放鬆身心")
                                .font(.caption)
                                .foregroundColor(AppColors.grayTextText)
                        }
                        
                        Spacer()
                        
                        // 右側佔位符，與左側按鈕寬度相同
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(AppColors.backgroundLight)
                
                // 模式選擇
                HStack(spacing: 0) {
                    ForEach(RelaxationMode.allCases, id: \.self) { mode in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedMode = mode
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(mode.displayName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedMode == mode ? mode.color : .grayText)
                                
                                Rectangle()
                                    .fill(selectedMode == mode ? mode.color : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                
                Spacer()
                
                // 時間選擇器
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            if let currentIndex = TimerConfiguration.availableDurations.firstIndex(of: selectedDuration),
                               currentIndex > 0 {
                                selectedDuration = TimerConfiguration.availableDurations[currentIndex - 1]
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(selectedMode.color)
                        }
                        .disabled(selectedDuration == TimerConfiguration.availableDurations.first)
                        
                        Spacer()
                        
                        Text("\(selectedDuration)分鐘")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedMode.color)
                        
                        Spacer()
                        
                        Button(action: {
                            if let currentIndex = TimerConfiguration.availableDurations.firstIndex(of: selectedDuration),
                               currentIndex < TimerConfiguration.availableDurations.count - 1 {
                                selectedDuration = TimerConfiguration.availableDurations[currentIndex + 1]
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(selectedMode.color)
                        }
                        .disabled(selectedDuration == TimerConfiguration.availableDurations.last)
                    }
                    .padding(.horizontal, 60)
                    
                    // 時間顯示圓圈
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        selectedMode.color.opacity(0.1),
                                        selectedMode.color.opacity(0.3)
                                    ]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 150
                                )
                            )
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.white.opacity(0.8),
                                        AppColors.white.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 160, height: 160)
                        
                        Text(String(format: "%d:00", selectedDuration))
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(selectedMode.color)
                    }
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.3), value: selectedDuration)
                }
                
                Spacer()
                
                // 移除首頁的 HRV 圖表顯示
                
                // 控制按鈕
                HStack(spacing: 20) {
                    Button(action: {
                        selectedDuration = 25
                    }) {
                        Text("重置")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedMode.color)
                            .frame(width: 100, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedMode.color, lineWidth: 2)
                                    )
                            )
                    }
                    
                    Button(action: {
                        showingSession = true
                    }) {
                        Text("開始")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                selectedMode.color,
                                                selectedMode.color.opacity(0.8)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    }
                }
                .padding(.bottom, 40)
            }
            .background(AppColors.backgroundLight)
            .navigationBarHidden(true)
            .overlay(
                // HRV 連接按鈕（右下角浮動）
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        if !hrvManager.isConnected {
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
                                        .fill(AppColors.orangeMain)
                                        .shadow(color: AppColors.orangeMain.opacity(0.4), radius: 8, x: 0, y: 4)
                                )
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 120)
                            .transition(.scale.combined(with: .opacity))
                        } else {
                            Button(action: {
                                withAnimation(.spring()) {
                                    hrvManager.disconnectDevice()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "heart.circle.fill")
                                        .font(.title3)
                                    
                                    Text("已連接")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(AppColors.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.moodCalm)
                                        .shadow(color: Color.moodCalm.opacity(0.4), radius: 8, x: 0, y: 4)
                                )
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 120)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
            )
            .fullScreenCover(isPresented: $showingSession) {
                RelaxationSessionView(
                    configuration: TimerConfiguration(
                        totalMinutes: selectedDuration,
                        mode: selectedMode,
                        breathingPattern: selectedMode == .breathing ? BreathingPattern.patterns[0] : nil
                    )
                )
            }
        }
    }
}

// MARK: - 放鬆會話視圖
struct RelaxationSessionView: View {
    let configuration: TimerConfiguration
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group {
            switch configuration.mode {
            case .breathing:
                BreathingView(configuration: configuration)
            case .meditation:
                MeditationView(configuration: configuration)
            }
        }
        .onAppear {
            HRVManager.shared.startHRVMonitoring()
        }
        .onDisappear {
            HRVManager.shared.stopHRVMonitoring()
        }
    }
}

#Preview {
    RelaxationView()
}
