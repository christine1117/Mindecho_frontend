import SwiftUI

struct DailyMoodSelector: View {
    @Binding var selectedMood: MoodType
    let onMoodSelected: (MoodType) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            selectedMood = mood
                            onMoodSelected(mood)
                        }
                    }) {
                        VStack(spacing: 6) {
                            Text(mood.emoji)
                                .font(.title2)
                                .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                            
                            Text(mood.rawValue)
                                .font(.caption2)
                                .foregroundColor(selectedMood == mood ? mood.color : .grayText)
                                .fontWeight(selectedMood == mood ? .bold : .regular)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedMood == mood ? mood.color.opacity(0.2) : Color.clear)
                                .animation(.easeInOut(duration: 0.2), value: selectedMood)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            if selectedMood != .neutral {
                Text("今天選擇了「\(selectedMood.rawValue)」")
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    DailyMoodSelector(
        selectedMood: .constant(.good),
        onMoodSelected: { _ in }
    )
    .padding()
}
