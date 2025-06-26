import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: Content
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let padding: EdgeInsets
    
    init(
        title: String? = nil,
        subtitle: String? = nil,
        backgroundColor: Color = Color.white,
        cornerRadius: CGFloat = 15,
        padding: EdgeInsets = EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15),
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 標題區域
            if let title = title {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.darkBrown)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.grayText)
                    }
                }
            }
            
            // 內容區域
            content
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 15) {
        SectionCard(title: "心情記錄", subtitle: "今天的感受") {
            Text("這裡是卡片內容")
                .foregroundColor(.grayText)
        }
        
        SectionCard(backgroundColor: AppColors.orange.opacity(0.1)) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(AppColors.orange)
                Text("無標題卡片")
                    .foregroundColor(AppColors.darkBrown)
                Spacer()
            }
        }
    }
    .padding()
    .background(AppColors.lightYellow)
}
