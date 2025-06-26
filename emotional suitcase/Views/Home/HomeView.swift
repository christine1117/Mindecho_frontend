import SwiftUI

struct HomeView: View {
    @State private var currentDate = Date()
    @State private var birthDate = Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1)) ?? Date()
    @State private var showingBiorhythmSettings = false
    @State private var selectedTimePeriod = "本週"
    @State private var animationProgress: Double = 0
    @State private var currentPage = 0
    @State private var showingDailyCheckIn = false
    
    @ObservedObject private var checkInManager = DailyCheckInManager.shared
    
    let timePeriodOptions = ["本週", "本月"]
    
    // 計算出生到現在的天數
    private var daysSinceBirth: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: birthDate, to: currentDate)
        return components.day ?? 0
    }
    
    // 生理節律計算 (23天週期)
    private var physicalBiorhythm: Double {
        sin(2 * .pi * Double(daysSinceBirth) * (1.0/23.0))
    }
    
    // 情緒節律計算 (28天週期)
    private var emotionalBiorhythm: Double {
        sin(2 * .pi * Double(daysSinceBirth) * (1.0/28.0))
    }
    
    // 智力節律計算 (33天週期)
    private var intellectualBiorhythm: Double {
        sin(2 * .pi * Double(daysSinceBirth) * (1.0/33.0))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 每日檢測提醒（如果還沒完成）
                    if !checkInManager.hasCompletedToday {
                        DailyCheckInReminderCard(onTap: {
                            showingDailyCheckIn = true
                        })
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
                    // 頁面指示器
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.brownDeep : AppColors.brownDeep.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)
                    
                    // 水平滑動視圖
                    TabView(selection: $currentPage) {
                        // 第一頁：五項指標追蹤卡片
                        VStack {
                            FiveIndicatorsCard(selectedTimePeriod: $selectedTimePeriod)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                                .frame(height: 350)
                            Spacer()
                        }
                        .tag(0)
                        
                        // 第二頁：生理節律卡片
                        VStack {
                            BiorhythmCard(
                                physicalBiorhythm: physicalBiorhythm,
                                emotionalBiorhythm: emotionalBiorhythm,
                                intellectualBiorhythm: intellectualBiorhythm,
                                currentDate: currentDate,
                                animationProgress: animationProgress,
                                onEditTapped: {
                                    showingBiorhythmSettings = true
                                }
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .frame(height: 350)
                            Spacer()
                        }
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 380)
                    
                    // 心理健康資源區塊
                    MentalHealthResourcesSection()
                        .padding(.top, 20)
                    
                    // 心理測驗區塊
                    PsychologicalTestsSection()
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                }
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("首頁")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                // 🧪 測試按鈕 - 開發時使用
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("重置今日檢測") {
                            checkInManager.resetTodayData()
                        }
                        
                        Button("清除所有數據", role: .destructive) {
                            checkInManager.clearAllData()
                        }
                        
                        Button("查看檢測狀態") {
                            print("今日已完成: \(checkInManager.hasCompletedToday)")
                            print("今日分數: \(String(describing: checkInManager.todayScores))")
                            print("週數據筆數: \(checkInManager.weeklyScores.count)")
                        }
                    } label: {
                        Image(systemName: "hammer.fill")
                            .foregroundColor(AppColors.brownDeep)
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0)) {
                    animationProgress = 1.0
                }
            }
        }
        .sheet(isPresented: $showingBiorhythmSettings) {
            BiorhythmSettingsView(
                currentDate: $currentDate,
                birthDate: $birthDate,
                isPresented: $showingBiorhythmSettings
            )
        }
        .sheet(isPresented: $showingDailyCheckIn) {
            DailyCheckInView(isPresented: $showingDailyCheckIn)
        }
    }
}

// MARK: - 每日檢測提醒卡片
struct DailyCheckInReminderCard: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "heart.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("今日健康檢測")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    Text("花1分鐘記錄今天的身心狀態")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        Text("開始檢測")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "list.clipboard.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [
                        AppColors.orangeMain,
                        AppColors.orange
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
