import SwiftUI

struct PhotoGridView: View {
    let photos: [SafeBoxItem]
    @ObservedObject var safeBoxManager: SafeBoxManager
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(photos) { photo in
                    PhotoCard(item: photo, onDelete: {
                        safeBoxManager.deletePhoto(photo)
                    })
                }
            }
            .padding()
        }
    }
}

struct PhotoCard: View {
    let item: SafeBoxItem
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 照片預覽
            Rectangle()
                .fill(AppColors.lightOrange)
                .aspectRatio(4/3, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(AppColors.orange.opacity(0.6))
                )
                .cornerRadius(12)
            
            // 照片資訊
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                
                Text(formatDate(item.date) + (item.description != nil ? " · \(item.description!)" : ""))
                    .font(.caption2)
                    .foregroundColor(.grayText)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppColors.orange)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(AppColors.orange)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: date)
}

#Preview {
    PhotoGridView(
        photos: [
            SafeBoxItem(title: "我和小黃的合照", date: Date(), type: .photo, duration: nil, description: "快樂的一天"),
            SafeBoxItem(title: "美好回憶", date: Date(), type: .photo, duration: nil, description: "快樂的一天")
        ],
        safeBoxManager: SafeBoxManager()
    )
}
