import SwiftUI

struct HealthDataView: View {
    @ObservedObject var trackingManager: TrackingDataManager
    @Binding var showingRecommendations: Bool
    @State private var selectedWeek = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 數據概覽標題
                SectionCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("數據概覽")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.darkBrown)
                            
                            Text("健康指標追蹤")
                                .font(.caption)
                                .foregroundColor(.grayText)
                        }
                        
                        Spacer()
                        
                        WeekNavigator(selectedWeek: $selectedWeek)
                    }
                }
                
                // 健康指標網格
                SectionCard(title: "本週數據") {
                    HealthMetricsGrid(
                        healthMetrics: trackingManager.healthMetrics
                    )
                }
                
                // 健康建議
                SectionCard(title: "健康建議") {
                    HealthRecommendationCard(
                        onViewMore: {
                            showingRecommendations = true
                        }
                    )
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HealthDataView(
        trackingManager: TrackingDataManager(),
        showingRecommendations: .constant(false)
    )
    .background(AppColors.lightYellow)
}
