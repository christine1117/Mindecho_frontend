import SwiftUI

struct DailyCheckInView: View {
    @Binding var isPresented: Bool
    @State private var currentQuestion = 0
    @State private var answers: [Int] = Array(repeating: -1, count: 5) // 改为 -1 表示未选择
    @State private var showingResult = false
    @State private var isFirstQuestion = true
    
    @ObservedObject private var checkInManager = DailyCheckInManager.shared
    
    let questions = [
        DailyCheckInQuestion(
            title: "你今天的身體感覺如何？",
            subtitle: "評估你的整體身體健康狀況",
            category: .physical
        ),
        DailyCheckInQuestion(
            title: "你今天的精神狀態如何？",
            subtitle: "評估你的專注力和清晰度",
            category: .mental
        ),
        DailyCheckInQuestion(
            title: "你今天的心情如何？",
            subtitle: "評估你的情緒穩定性",
            category: .emotional
        ),
        DailyCheckInQuestion(
            title: "你昨晚的睡眠品質如何？",
            subtitle: "評估你的睡眠品質和充足度",
            category: .sleep
        ),
        DailyCheckInQuestion(
            title: "你今天的食慾如何？",
            subtitle: "評估你的壓力狀態",
            category: .appetite
        )
    ]
    
    let moodOptions = [
        MoodOption(emoji: "😰", label: "很差", value: 20),
        MoodOption(emoji: "😞", label: "不好", value: 40),
        MoodOption(emoji: "😐", label: "一般", value: 60),
        MoodOption(emoji: "😊", label: "良好", value: 80),
        MoodOption(emoji: "😄", label: "極佳", value: 100)
    ]
    
    var body: some View {
        NavigationView {
            if showingResult {
                DailyCheckInResultView(
                    scores: calculateScores(),
                    isPresented: $isPresented
                )
            } else if isFirstQuestion {
                welcomeView
            } else {
                questionView
            }
        }
    }
    
    // MARK: - 歡迎頁面
    private var welcomeView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // 裝飾方框
            VStack(spacing: 32) {
                // 標題區塊
                VStack(spacing: 12) {
                    Text("歡迎來到情緒行李箱 Emotional Suticase")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    
                    Text("花一分鐘記錄今天的狀態，幫助你更好地了解自己的健康趨勢。")
                        .font(.body)
                        .foregroundColor(AppColors.brownDeep)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8)
                
                // 開始按鈕
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isFirstQuestion = false
                    }
                }) {
                    Text("開始檢測")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.orangeMain)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 12)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundLight)
        .navigationBarItems(trailing: Button("關閉") { isPresented = false })
    }
    
    // MARK: - 問題頁面
    private var questionView: some View {
        VStack(spacing: 0) {
            // 進度條
            VStack(spacing: 8) {
                ProgressView(value: Double(currentQuestion + 1), total: Double(questions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.orangeMain))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text("問題\(currentQuestion + 1)/\(questions.count)")
                    .font(.caption)
                    .foregroundColor(AppColors.orangeMain)
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            // 問題卡片
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text(questions[currentQuestion].title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                        .multilineTextAlignment(.center)
                    
                    Text(questions[currentQuestion].subtitle)
                        .font(.subheadline)
                        .foregroundColor(AppColors.brownDeep.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // 情緒選項
                HStack(spacing: 12) {
                    ForEach(0..<moodOptions.count, id: \.self) { index in
                        MoodButton(
                            option: moodOptions[index],
                            isSelected: answers[currentQuestion] == index,
                            onTap: {
                                selectAnswer(index)
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                
                // 導航按鈕
                HStack(spacing: 16) {
                    if currentQuestion > 0 {
                        Button(action: previousQuestion) {
                            Text("上一題")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(AppColors.brownDeep)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AppColors.backgroundLight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(AppColors.brownDeep, lineWidth: 1)
                                )
                        }
                        .transition(.slide)
                    }
                    
                    Button(action: nextQuestion) {
                        Text(currentQuestion == questions.count - 1 ? "完成檢測" : "下一題")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColors.orangeMain)
                            .cornerRadius(8)
                    }
                    .disabled(answers[currentQuestion] == -1) // 改为检查是否为 -1
                    .opacity(answers[currentQuestion] == -1 ? 0.5 : 1.0) // 改为检查是否为 -1
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
            }
            .padding(.vertical, 32)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8)
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(AppColors.backgroundLight)
        .navigationBarItems(trailing: Button("關閉") { isPresented = false })
    }
    
    // MARK: - 私有方法
    private func selectAnswer(_ index: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            answers[currentQuestion] = index
        }
    }
    
    private func previousQuestion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentQuestion > 0 {
                currentQuestion -= 1
            }
        }
    }
    
    private func nextQuestion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentQuestion < questions.count - 1 {
                currentQuestion += 1
            } else {
                // 保存結果
                let scores = calculateScores()
                checkInManager.saveDailyCheckIn(scores: scores)
                showingResult = true
            }
        }
    }
    
    private func calculateScores() -> DailyCheckInScores {
        return DailyCheckInScores(
            physical: moodOptions[answers[0]].value,
            mental: moodOptions[answers[1]].value,
            emotional: moodOptions[answers[2]].value,
            sleep: moodOptions[answers[3]].value,
            appetite: moodOptions[answers[4]].value,
            date: Date()
        )
    }
}

// MARK: - 情緒按鈕
struct MoodButton: View {
    let option: MoodOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: onTap) {
                VStack(spacing: 6) {
                    Text(option.emoji)
                        .font(.system(size: 32))
                    
                    Text(option.label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.brownDeep)
                }
                .frame(width: 60, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AppColors.orangeMain.opacity(0.2) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSelected ? AppColors.orangeMain : Color.grayText.opacity(0.3),
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )
                )
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

// MARK: - 數據模型
struct DailyCheckInQuestion {
    let title: String
    let subtitle: String
    let category: HealthCategory
}

struct MoodOption {
    let emoji: String
    let label: String
    let value: Int
}

enum HealthCategory {
    case physical, mental, emotional, sleep, appetite
}

#Preview {
    DailyCheckInView(isPresented: .constant(true))
}
