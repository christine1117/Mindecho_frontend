import SwiftUI

// MARK: - 24小時心理諮詢熱線
struct HotlineDetailView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text("24小時心理諮詢熱線")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    VStack(spacing: 16) {
                        HotlineCard(
                            title: "生命線協談專線",
                            number: "1995",
                            description: "24小時免費心理諮詢服務",
                            icon: "heart.fill"
                        )
                        
                        HotlineCard(
                            title: "張老師專線",
                            number: "1980",
                            description: "青少年輔導專線",
                            icon: "person.fill"
                        )
                        
                        HotlineCard(
                            title: "安心專線",
                            number: "1925",
                            description: "心理健康諮詢服務",
                            icon: "brain.head.profile"
                        )
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📞 使用提醒")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• 所有專線均提供免費諮詢服務")
                            Text("• 通話內容完全保密")
                            Text("• 如遇危急情況，請立即撥打 119 或前往急診室")
                            Text("• 專業諮詢師將提供情緒支持與建議")
                        }
                        .font(.body)
                        .foregroundColor(AppColors.brownDeep)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2)
                }
                .padding()
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("心理諮詢熱線")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("關閉") { isPresented = false })
        }
    }
}

struct HotlineCard: View {
    let title: String
    let number: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(AppColors.brownDeep)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.brownDeep)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColors.brownDeep.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "tel:\(number)") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text(number)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppColors.brownDeep)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}

// MARK: - 心理健康指南
struct GuideDetailView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "book.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text("心理健康指南")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    VStack(spacing: 16) {
                        GuideCard(
                            title: "認識憂鬱症",
                            description: "了解憂鬱症的症狀、成因與治療方式",
                            icon: "heart.circle"
                        )
                        
                        GuideCard(
                            title: "焦慮症指南",
                            description: "學習識別和管理焦慮症狀",
                            icon: "brain.head.profile"
                        )
                        
                        GuideCard(
                            title: "壓力管理",
                            description: "有效的壓力調節技巧和方法",
                            icon: "leaf.circle"
                        )
                        
                        GuideCard(
                            title: "睡眠健康",
                            description: "改善睡眠品質的實用建議",
                            icon: "moon.circle"
                        )
                        
                        GuideCard(
                            title: "人際關係",
                            description: "建立健康的人際互動模式",
                            icon: "person.2.circle"
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📚 使用說明")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• 本指南提供基礎心理健康知識")
                            Text("• 內容僅供參考，不能替代專業醫療建議")
                            Text("• 如有嚴重症狀，請尋求專業協助")
                            Text("• 定期閱讀有助於提升心理健康意識")
                        }
                        .font(.body)
                        .foregroundColor(AppColors.brownDeep)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2)
                }
                .padding()
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("心理健康指南")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("關閉") { isPresented = false })
        }
    }
}

struct GuideCard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(AppColors.brownDeep)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.brownDeep)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColors.brownDeep.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                // 這裡可以導航到具體的指南頁面
            }) {
                Text("查看")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(AppColors.brownDeep)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}

// MARK: - 情緒管理技巧
struct TechniquesDetailView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text("情緒管理技巧")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    VStack(spacing: 16) {
                        TechniqueCard(
                            title: "深呼吸練習",
                            description: "4-7-8 呼吸法緩解焦慮情緒",
                            steps: ["吸氣4秒", "憋氣7秒", "呼氣8秒", "重複4-6次"],
                            icon: "lungs.fill"
                        )
                        
                        TechniqueCard(
                            title: "正念冥想",
                            description: "專注當下，觀察思緒和感受",
                            steps: ["找安靜環境", "閉眼專注呼吸", "觀察念頭飄過", "持續5-10分鐘"],
                            icon: "brain.head.profile"
                        )
                        
                        TechniqueCard(
                            title: "肌肉放鬆",
                            description: "漸進式肌肉放鬆技巧",
                            steps: ["繃緊肌肉5秒", "突然放鬆", "感受對比", "從腳到頭依序進行"],
                            icon: "figure.flexibility"
                        )
                        
                        TechniqueCard(
                            title: "情緒日記",
                            description: "記錄和分析情緒變化",
                            steps: ["記錄觸發事件", "描述情緒感受", "分析思維模式", "尋找應對方式"],
                            icon: "book.fill"
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("💡 使用建議")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• 選擇適合自己的技巧定期練習")
                            Text("• 在情緒平穩時先學習技巧")
                            Text("• 持續練習才能見到效果")
                            Text("• 結合多種技巧效果更佳")
                        }
                        .font(.body)
                        .foregroundColor(AppColors.brownDeep)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2)
                }
                .padding()
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("情緒管理技巧")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("關閉") { isPresented = false })
        }
    }
}

struct TechniqueCard: View {
    let title: String
    let description: String
    let steps: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(AppColors.brownDeep)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(AppColors.brownDeep.opacity(0.7))
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("步驟：")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.brownDeep)
                
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(spacing: 8) {
                        Text("\(index + 1).")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.orangeMain)
                            .frame(width: 20, alignment: .leading)
                        
                        Text(step)
                            .font(.caption)
                            .foregroundColor(AppColors.brownDeep)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}

// MARK: - 附近心理診所
struct MapDetailView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text("附近心理診所")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    VStack(spacing: 16) {
                        ClinicCard(
                            name: "心安診所",
                            address: "台北市中正區重慶南路一段10號",
                            phone: "02-2388-1234",
                            specialties: ["憂鬱症", "焦慮症", "睡眠障礙"],
                            distance: "0.5公里"
                        )
                        
                        ClinicCard(
                            name: "康心身心科診所",
                            address: "台北市大安區敦化南路二段76號",
                            phone: "02-2325-5678",
                            specialties: ["心理諮商", "壓力管理", "人際關係"],
                            distance: "1.2公里"
                        )
                        
                        ClinicCard(
                            name: "樂活心理治療所",
                            address: "台北市信義區松高路11號8樓",
                            phone: "02-2722-9876",
                            specialties: ["認知行為治療", "家庭治療", "創傷治療"],
                            distance: "2.1公里"
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🏥 就醫提醒")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• 建議事先電話預約")
                            Text("• 攜帶健保卡和身分證件")
                            Text("• 可準備相關病史和用藥紀錄")
                            Text("• 如需要可請家人陪同")
                        }
                        .font(.body)
                        .foregroundColor(AppColors.brownDeep)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2)
                }
                .padding()
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("附近心理診所")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("關閉") { isPresented = false })
        }
    }
}

struct ClinicCard: View {
    let name: String
    let address: String
    let phone: String
    let specialties: [String]
    let distance: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(AppColors.brownDeep)
                    
                    Text(distance)
                        .font(.caption)
                        .foregroundColor(AppColors.orangeMain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppColors.orangeMain.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Button(action: {
                    if let url = URL(string: "tel:\(phone)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(AppColors.brownDeep)
                        .cornerRadius(8)
                }
            }
            
            Text(address)
                .font(.subheadline)
                .foregroundColor(AppColors.brownDeep.opacity(0.7))
            
            Text("專長：\(specialties.joined(separator: "、"))")
                .font(.caption)
                .foregroundColor(AppColors.brownDeep)
            
            HStack(spacing: 8) {
                Button(action: {
                    // 導航功能
                }) {
                    Text("導航")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.brownDeep)
                        .cornerRadius(6)
                }
                
                Button(action: {
                    // 預約功能
                }) {
                    Text("預約")
                        .font(.caption)
                        .foregroundColor(AppColors.brownDeep)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(AppColors.brownDeep, lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}
