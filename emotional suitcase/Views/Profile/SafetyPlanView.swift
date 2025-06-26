import SwiftUI

struct SafetyPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var emergencyManager = EmergencyDataManager()
    @State private var showingAddContact = false
    @State private var showingAddProfessional = false
    @State private var showingAddWarningSign = false
    @State private var showingAddCopingStrategy = false
    @State private var showingAddSafetyMethod = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. 警示信號
                    SafetyPlanSection(
                        title: "1.警示信號",
                        items: [
                            "感到極度孤獨和絕望",
                            "無法入睡或睡眠過多"
                        ],
                        addButtonText: "添加更多信號",
                        onAddTap: {
                            showingAddWarningSign = true
                        }
                    )
                    
                    // 2. 自我安撫策略
                    SafetyPlanSection(
                        title: "2.自我安撫策略",
                        items: [
                            "深呼吸練習（吸4秒，屏息4秒，呼氣6秒）",
                            "冷水沖洗手腕或臉部"
                        ],
                        addButtonText: "添加更多信號",
                        onAddTap: {
                            showingAddCopingStrategy = true
                        }
                    )
                    
                    // 3. 可聯繫的親友
                    VStack(alignment: .leading, spacing: 15) {
                        Text("3. 可聯繫的親友")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.darkBrown)
                        
                        VStack(spacing: 8) {
                            ForEach(emergencyManager.friendContacts) { contact in
                                SafetyContactRow(contact: contact, onDelete: {
                                    emergencyManager.deleteFriendContact(contact)
                                })
                            }
                            
                            // 修改：將按鈕靠左對齊
                            HStack {
                                Button(action: {
                                    showingAddContact = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("添加聯繫人")
                                    }
                                    .font(.caption)
                                    .foregroundColor(AppColors.orange)
                                    .padding(.vertical, 8)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(red: 0.98, green: 0.94, blue: 0.80))
                        .cornerRadius(12)
                    }

                    // 4. 專業協助
                    VStack(alignment: .leading, spacing: 15) {
                        Text("4. 專業協助")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.darkBrown)
                        
                        VStack(spacing: 8) {
                            ForEach(emergencyManager.professionalContacts) { contact in
                                SafetyContactRow(contact: contact, onDelete: {
                                    emergencyManager.deleteProfessionalContact(contact)
                                })
                            }
                            
                            // 24小時救援專線
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("24小時救援專線")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppColors.darkBrown)
                                    Text("1925 (依舊愛我)")
                                        .font(.caption)
                                        .foregroundColor(.grayText)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if let url = URL(string: "tel://1925") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(AppColors.orange)
                                        .font(.title3)
                                }
                            }
                            .padding(.vertical, 5)
                            
                            // 修改：將按鈕靠左對齊
                            HStack {
                                Button(action: {
                                    showingAddProfessional = true
                                }) {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("添加專業聯絡人")
                                    }
                                    .font(.caption)
                                    .foregroundColor(AppColors.orange)
                                    .padding(.vertical, 8)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(red: 0.98, green: 0.94, blue: 0.80))
                        .cornerRadius(12)
                    }

                    // 5. 安全環境
                    SafetyPlanSection(
                        title: "5.安全環境",
                        items: [
                            "移除藥物到安全處",
                            "把槍給多拉A夢保管"
                        ],
                        addButtonText: "添加更多方法",
                        onAddTap: {
                            showingAddSafetyMethod = true
                        }
                    )
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(AppColors.lightYellow)
            .navigationTitle("安全計畫")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("✕") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .toolbarBackground(AppColors.mediumBrown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showingAddContact) {
            AddEmergencyContactView(emergencyManager: emergencyManager, contactType: .friend)
        }
        .sheet(isPresented: $showingAddProfessional) {
            AddEmergencyContactView(emergencyManager: emergencyManager, contactType: .professional)
        }
        .sheet(isPresented: $showingAddWarningSign) {
            AddSafetyItemView(title: "新增警示信號", placeholder: "例如：感到極度孤獨")
        }
        .sheet(isPresented: $showingAddCopingStrategy) {
            AddSafetyItemView(title: "新增應對策略", placeholder: "例如：聽音樂放鬆")
        }
        .sheet(isPresented: $showingAddSafetyMethod) {
            AddSafetyItemView(title: "新增安全方法", placeholder: "例如：移除危險物品")
        }
        .onAppear {
            loadSampleData()
        }
    }
    
    private func loadSampleData() {
        // 範例數據已經在 EmergencyDataManager 的 init 中載入
    }
}

// 通用的安全計畫區塊
struct SafetyPlanSection: View {
    let title: String
    let items: [String]
    let addButtonText: String
    let backgroundColor: Color = Color(red: 0.98, green: 0.94, blue: 0.80) // 更亮的淺黃色
    let onAddTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.darkBrown)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(AppColors.darkBrown)
                        Text(item)
                            .font(.body)
                            .foregroundColor(AppColors.darkBrown)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
                // 靠左對齊的添加按鈕
                HStack {
                    Button(action: onAddTap) {
                        HStack {
                            Image(systemName: "plus")
                            Text(addButtonText)
                        }
                        .font(.caption)
                        .foregroundColor(AppColors.orange)
                        .padding(.vertical, 8)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
        }
    }
}

// 聯絡人行
struct SafetyContactRow: View {
    let contact: EmergencyContact
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(contact.name) (\(contact.relationship))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.darkBrown)
                Text(contact.phone)
                    .font(.caption)
                    .foregroundColor(.grayText)
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "tel://\(contact.phone)") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(AppColors.orange)
                    .font(.title3)
            }
        }
        .padding(.vertical, 5)
    }
}

struct AddEmergencyContactView: View {
    @ObservedObject var emergencyManager: EmergencyDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var relationship = ""
    let contactType: ContactType
    
    enum ContactType {
        case friend
        case professional
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("姓名", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("電話號碼", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                
                TextField("關係 (例如：家人、朋友)", text: $relationship)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    switch contactType {
                    case .friend:
                        emergencyManager.addFriendContact(name: name, phone: phone, relationship: relationship)
                    case .professional:
                        emergencyManager.addProfessionalContact(name: name, phone: phone, relationship: relationship)
                    }
                    dismiss()
                }) {
                    Text("保存")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.orange)
                        .cornerRadius(12)
                }
                .disabled(name.isEmpty || phone.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle(contactType == .friend ? "新增親友聯絡人" : "新增專業聯絡人")
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

struct AddSafetyItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    let title: String
    let placeholder: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // 這裡可以添加保存邏輯
                    dismiss()
                }) {
                    Text("保存")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.orange)
                        .cornerRadius(12)
                }
                .disabled(text.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle(title)
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

#Preview {
    SafetyPlanView()
}
