import SwiftUI

struct SupportPlanView: View {
    @StateObject private var emergencyManager = EmergencyDataManager()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 我的理由清單
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("我的理由清單")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddEntry = true
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("新理由")
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.orange)
                                .cornerRadius(8)
                            }
                        }
                        
                        Text("這些信念和你想前往的理由")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        
                        ForEach(emergencyManager.supportEntries) { entry in
                            SupportEntryCard(
                                entry: entry,
                                onDelete: {
                                    emergencyManager.deleteSupportEntry(entry)
                                }
                            )
                        }
                    }
                    
                    // 設定提醒
                    VStack(alignment: .leading, spacing: 15) {
                        Text("設定提醒")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.darkBrown)
                        
                        Text("選擇何時收到你的理由提醒：")
                            .font(.caption)
                            .foregroundColor(.grayText)
                        
                        HStack(spacing: 10) {
                            ReminderButton(title: "每天早上", isSelected: true)
                            ReminderButton(title: "每天中午", isSelected: false)
                            ReminderButton(title: "睡前", isSelected: false)
                            ReminderButton(title: "自訂", isSelected: false)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                }
                .padding()
            }
            .background(AppColors.lightYellow)
            .navigationTitle("支援我的片刻")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("✕") {
                        dismiss()
                    }
                    .foregroundColor(.white) // 改為白色
                }
            }
            .toolbarBackground(Color(red: 0.95, green: 0.75, blue: 0.30), for: .navigationBar) // 改為黃色
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar) // 讓標題文字變白色
        }
        .sheet(isPresented: $showingAddEntry) {
            AddSupportEntryView(emergencyManager: emergencyManager)
        }
    }
}

struct SupportEntryCard: View {
    let entry: SupportEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: entry.icon)
                .font(.title2)
                .foregroundColor(AppColors.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(entry.content)
                    .font(.caption)
                    .foregroundColor(.grayText)
                    .multilineTextAlignment(.leading)
                
                Text(formatEntryDate(entry.date))
                    .font(.caption2)
                    .foregroundColor(.grayText)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(AppColors.orange)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(AppColors.orange)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ReminderButton: View {
    let title: String
    @State var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : AppColors.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.orange : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.orange, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}

struct AddSupportEntryView: View {
    @ObservedObject var emergencyManager: EmergencyDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("標題", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $content)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.grayText.opacity(0.3), lineWidth: 1)
                    )
                
                Button(action: {
                    emergencyManager.addSupportEntry(title: title, content: content)
                    dismiss()
                }) {
                    Text("保存")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.orange)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("新增理由")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}

func formatEntryDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.string(from: date)
}

#Preview {
    SupportPlanView()
}
