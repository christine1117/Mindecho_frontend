import SwiftUI

struct EmergencyContactCard: View {
    let contact: EmergencyContact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(contact.name)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.darkBrown)
            
            Text(contact.phone)
                .font(.caption)
                .foregroundColor(.grayText)
            
            Text(contact.relationship)
                .font(.caption2)
                .foregroundColor(AppColors.orange)
            
            Button(action: {
                if let url = URL(string: "tel://\(contact.phone.replacingOccurrences(of: "-", with: ""))") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                    Text("立即撥打")
                        .font(.caption)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(AppColors.orange)
                .cornerRadius(6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.95, green: 0.75, blue: 0.30), lineWidth: 1.5)
        )
    }
}

#Preview {
    EmergencyContactCard(
        contact: EmergencyContact(
            name: "測試聯絡人",
            phone: "0912-345-678",
            relationship: "朋友"
        )
    )
    .padding()
}
