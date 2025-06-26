import SwiftUI

struct VideoGridView: View {
    let videos: [SafeBoxItem]
    @ObservedObject var safeBoxManager: SafeBoxManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(videos) { video in
                    VideoCard(item: video, onDelete: {
                        safeBoxManager.deleteVideo(video)
                    })
                }
            }
            .padding()
        }
    }
}

struct VideoCard: View {
    let item: SafeBoxItem
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 影片預覽
            Rectangle()
                .fill(AppColors.lightOrange)
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.orange.opacity(0.8))
                        
                        Text("影片預覽")
                            .font(.caption)
                            .foregroundColor(AppColors.orange.opacity(0.6))
                    }
                )
                .cornerRadius(12)
            
            // 影片資訊
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(item.description ?? "")
                    .font(.caption)
                    .foregroundColor(.grayText)
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppColors.orange)
                    }
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(AppColors.orange)
                    }
                }
            }
            .padding(.horizontal, 5)
        }
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    VideoGridView(
        videos: [
            SafeBoxItem(title: "海浪聲音", date: Date(), type: .video, duration: 120, description: "放鬆影片"),
            SafeBoxItem(title: "雨聲", date: Date(), type: .video, duration: 90, description: "放鬆影片")
        ],
        safeBoxManager: SafeBoxManager()
    )
}
