import SwiftUI

struct BiorhythmSettingsView: View {
    @Binding var currentDate: Date
    @Binding var birthDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("請輸入日期")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("出生日期")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("當前日期")
                            .font(.headline)
                            .foregroundColor(AppColors.brownDeep)
                        
                        DatePicker("", selection: $currentDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                }
                .padding()
                
                Button("計算我的生理節律") {
                    isPresented = false
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.brownDeep)
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("生理節律解讀")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.brownDeep)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("身體生理節律 (23天)：影響身心的體力、耐力，以及身心和各種運動機能。")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.brownDeep)
                        
                        Text("情緒生理節律 (28天)：影響感性的情緒調節性，情緒控制穩定性，適合社交活動和一般人際互動。")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.brownDeep)
                        
                        Text("智力生理節律 (33天)：影響理性的思維能力，邏輯推理，記憶力和學習等認知能力。")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.brownDeep)
                    }
                    .padding()
                    .background(AppColors.brownDeep.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                
                Spacer()
            }
            .background(AppColors.backgroundLight)
            .navigationTitle("生理節律計算")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("✕") {
                    isPresented = false
                }
                .foregroundColor(AppColors.brownDeep)
            )
        }
    }
}
