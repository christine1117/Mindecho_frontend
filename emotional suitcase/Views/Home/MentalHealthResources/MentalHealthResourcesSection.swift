import SwiftUI

struct MentalHealthResourcesSection: View {
    @State private var showingHotlineSheet = false
    @State private var showingGuideSheet = false
    @State private var showingTechniquesSheet = false
    @State private var showingMapSheet = false
    
    let resources = [
        MentalHealthResource(
            title: "24小時心理諮詢熱線",
            subtitle: "專業心理師即時協助",
            icon: "phone.fill",
            buttonText: "立即撥打",
            action: .hotline
        ),
        MentalHealthResource(
            title: "心理健康指南",
            subtitle: "全面了解心理健康知識",
            icon: "book.fill",
            buttonText: "查看更多",
            action: .guide
        ),
        MentalHealthResource(
            title: "情緒管理技巧",
            subtitle: "學習有效調節情緒方法",
            icon: "heart.circle.fill",
            buttonText: "查看更多",
            action: .techniques
        ),
        MentalHealthResource(
            title: "附近心理診所",
            subtitle: "尋找專業醫療協助",
            icon: "location.fill",
            buttonText: "查看地圖",
            action: .map
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("心理健康資源")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.brownDeep)
                    .padding(.leading, 16)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(resources) { resource in
                        MentalHealthResourceCard(
                            resource: resource,
                            onTap: {
                                switch resource.action {
                                case .hotline:
                                    showingHotlineSheet = true
                                case .guide:
                                    showingGuideSheet = true
                                case .techniques:
                                    showingTechniquesSheet = true
                                case .map:
                                    showingMapSheet = true
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingHotlineSheet) {
            HotlineDetailView(isPresented: $showingHotlineSheet)
        }
        .sheet(isPresented: $showingGuideSheet) {
            GuideDetailView(isPresented: $showingGuideSheet)
        }
        .sheet(isPresented: $showingTechniquesSheet) {
            TechniquesDetailView(isPresented: $showingTechniquesSheet)
        }
        .sheet(isPresented: $showingMapSheet) {
            MapDetailView(isPresented: $showingMapSheet)
        }
    }
}
