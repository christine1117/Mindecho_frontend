import SwiftUI

struct MoodDiaryView: View {
    @ObservedObject var trackingManager: TrackingDataManager
    @Binding var showingAnalysis: Bool
    @State private var showingDiaryEditor = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 心情日曆
                SectionCard(title: "心情日曆") {
                    MoodCalendarView(
                        trackingManager: trackingManager,
                        selectedDate: $selectedDate
                    )
                }
                
                // 今天的心情
                SectionCard(title: "今天的心情", subtitle: "選擇你現在的感受") {
                    DailyMoodSelector(
                        selectedMood: $trackingManager.currentMood,
                        onMoodSelected: { mood in
                            trackingManager.addMoodEntry(mood)
                        }
                    )
                }
                
                // 心情日記
                SectionCard(title: "心情日記", subtitle: "記錄你的想法和感受") {
                    VStack(spacing: 15) {
                        Button(action: {
                            showingDiaryEditor = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(AppColors.orange)
                                Text("寫下今天的心情...")
                                    .foregroundColor(.grayText)
                                Spacer()
                            }
                            .padding()
                            .background(Color.grayText.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showingAnalysis = true
                        }) {
                            HStack {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .foregroundColor(.white)
                                Text("查看本月分析")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(AppColors.orange)
                            .cornerRadius(10)
                        }
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingDiaryEditor) {
            MoodDiaryEditor(
                trackingManager: trackingManager,
                selectedDate: selectedDate
            )
        }
    }
}

#Preview {
    MoodDiaryView(
        trackingManager: TrackingDataManager(),
        showingAnalysis: .constant(false)
    )
    .background(AppColors.lightYellow)
}
