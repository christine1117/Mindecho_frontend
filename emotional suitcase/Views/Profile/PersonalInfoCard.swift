import SwiftUI

struct PersonalInfoCard: View {
    let profileData: ProfileData
    @Binding var selectedMood: String
    let onMoodTap: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                // 頭像和名字
                HStack(spacing: 15) {
                    Circle()
                        .fill(AppColors.orange)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("小")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(profileData.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.darkBrown)
                        
                        Text("這是一個屬於你的安全空間，在這裡可以整理情緒、收集力量、找到希望。")
                            .font(.caption)
                            .foregroundColor(.grayText)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // 右上角快速心情按鈕
                Button(action: onMoodTap) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.30))
                }
            }
            
            // 今天心情（移到左邊，動態顏色）
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("今天心情：\(selectedMood)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(getMoodColor(mood: selectedMood))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
    
    // 根據心情返回對應顏色
    func getMoodColor(mood: String) -> Color {
        switch mood {
        case "平靜":
            return Color(red: 0.95, green: 0.75, blue: 0.30) // 黃色
        case "開心":
            return AppColors.orange // 橘色
        case "難過":
            return Color.blue
        case "生氣":
            return Color.moodAngry
        case "焦慮":
            return Color.purple
        default:
            return Color(red: 0.95, green: 0.75, blue: 0.30) // 預設黃色
        }
    }
}

#Preview {
    PersonalInfoCard(
        profileData: ProfileData(
            name: "小美",
            todayMood: "平靜",
            checkInDays: 7,
            todayQuote: "你的故事還沒有結束"
        ),
        selectedMood: .constant("平靜"),
        onMoodTap: {}
    )
    .padding()
    .background(AppColors.lightYellow)
}
