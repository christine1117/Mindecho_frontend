import SwiftUI

struct StatusTag: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.grayText)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 1.0, green: 0.9, blue: 0.6))
                .cornerRadius(12)
        }
    }
}

#Preview {
    HStack {
        StatusTag(title: "今天感覺", value: "平靜")
        StatusTag(title: "連續登入", value: "7 天")
    }
    .padding()
}
