import SwiftUI

struct PsychologicalTestsSection: View {
    @State private var showingPHQ9Test = false
    @State private var showingGAD7Test = false
    @State private var showingBSRS5Test = false
    @State private var showingRFQ8Test = false
    
    let tests = [
        PsychologicalTest(
            title: "PHQ-9 憂鬱症篩檢",
            subtitle: "評估憂鬱症狀嚴重程度",
            icon: "heart.circle.fill",
            duration: "3分鐘",
            questions: "9題",
            lastTaken: "未測驗",
            action: .phq9
        ),
        PsychologicalTest(
            title: "GAD-7 焦慮症篩檢",
            subtitle: "評估廣泛性焦慮症狀",
            icon: "brain.head.profile",
            duration: "2分鐘",
            questions: "7題",
            lastTaken: "未測驗",
            action: .gad7
        ),
        PsychologicalTest(
            title: "BSRS-5 心理症狀量表",
            subtitle: "篩檢心理健康狀況",
            icon: "list.clipboard.fill",
            duration: "2分鐘",
            questions: "5題",
            lastTaken: "未測驗",
            action: .bsrs5
        ),
        PsychologicalTest(
            title: "RFQ-8 反思功能量表",
            subtitle: "評估心智化能力",
            icon: "lightbulb.fill",
            duration: "3分鐘",
            questions: "8題",
            lastTaken: "未測驗",
            action: .rfq8
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("心理測驗")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                    .padding(.leading, 16)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tests) { test in
                        PsychologicalTestCard(
                            test: test,
                            onTap: {
                                switch test.action {
                                case .phq9:
                                    showingPHQ9Test = true
                                case .gad7:
                                    showingGAD7Test = true
                                case .bsrs5:
                                    showingBSRS5Test = true
                                case .rfq8:
                                    showingRFQ8Test = true
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingPHQ9Test) {
            PHQ9TestView(isPresented: $showingPHQ9Test)
        }
        .sheet(isPresented: $showingGAD7Test) {
            GAD7TestView(isPresented: $showingGAD7Test)
        }
        .sheet(isPresented: $showingBSRS5Test) {
            BSRS5TestView(isPresented: $showingBSRS5Test)
        }
        .sheet(isPresented: $showingRFQ8Test) {
            RFQ8TestView(isPresented: $showingRFQ8Test)
        }
    }
}
