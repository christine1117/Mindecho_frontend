import SwiftUI

struct AudioListView: View {
    let audios: [SafeBoxItem]
    @ObservedObject var safeBoxManager: SafeBoxManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(audios) { audio in
                    AudioCard(item: audio, onDelete: {
                        safeBoxManager.deleteAudio(audio)
                    })
                }
            }
            .padding()
        }
    }
}

struct AudioCard: View {
    let item: SafeBoxItem
    let onDelete: () -> Void
    @State private var isPlaying = false
    
    var body: some View {
        HStack(spacing: 15) {
            // 播放按鈕
            Button(action: {
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.orange)
            }
            
            // 音訊資訊
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                // 進度條
                HStack {
                    Rectangle()
                        .fill(AppColors.orange)
                        .frame(height: 4)
                        .frame(maxWidth: isPlaying ? 100 : 60)
                        .animation(.easeInOut(duration: 0.3), value: isPlaying)
                    
                    Rectangle()
                        .fill(Color.grayText.opacity(0.3))
                        .frame(height: 4)
                    
                    Text(formatDuration(item.duration ?? 0))
                        .font(.caption2)
                        .foregroundColor(.grayText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            // 刪除按鈕
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(AppColors.orange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

func formatDuration(_ duration: TimeInterval) -> String {
    let minutes = Int(duration) / 60
    let seconds = Int(duration) % 60
    return String(format: "%d:%02d", minutes, seconds)
}

#Preview {
    AudioListView(
        audios: [
            SafeBoxItem(title: "媽媽的鼓勵", date: Date(), type: .audio, duration: 90, description: nil),
            SafeBoxItem(title: "爸爸的話", date: Date(), type: .audio, duration: 120, description: nil)
        ],
        safeBoxManager: SafeBoxManager()
    )
}
