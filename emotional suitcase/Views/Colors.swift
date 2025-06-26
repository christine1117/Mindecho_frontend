import SwiftUI

struct AppColors {
    // 主色系
    static let orange = Color(red: 0.89, green: 0.49, blue: 0.20) // #E37D33
    static let orangeMain = AppColors.orangeMain // #CC661A
    static let orangeLight = Color(red: 0.9, green: 0.4, blue: 0.2) // #E66633
    static let yellowMain = Color(red: 0.95, green: 0.75, blue: 0.30) // #F2BF4C
    static let yellowLight = Color(red: 1.0, green: 0.9, blue: 0.6) // #FFE699
    static let yellowBackground = Color(red: 0.98, green: 0.94, blue: 0.80) // #FAF0CC
    static let yellowAccent = Color(red: 0.98, green: 0.94, blue: 0.87) // #FAF0DE
    static let yellowStrong = Color(red: 1.0, green: 0.8, blue: 0.5) // #FFD980
    static let yellowMid = Color(red: 1.0, green: 0.6, blue: 0.3) // #FF9933
    static let lightYellow = Color(red: 1.0, green: 0.98, blue: 0.8) // #FFFCCC（補回相容用）
    // 棕色系
    static let darkBrown = Color(red: 0.40, green: 0.26, blue: 0.13) // #664321
    static let mediumBrown = Color(red: 0.55, green: 0.35, blue: 0.20) // #8C5932
    static let lightBrown = Color(red: 0.70, green: 0.55, blue: 0.40) // #B38C66
    static let brownDeep = AppColors.brownDeep // #663319
    static let brownMid = Color(red: 0.6, green: 0.3, blue: 0.1) // #995019
    static let brownStrong = Color(red: 0.7, green: 0.2, blue: 0.1) // #B23319
    // 其他色系
    static let moodHappy = Color(red: 1.0, green: 0.6, blue: 0.3) // #FF9933
    static let moodSad = Color(red: 0.5, green: 0.7, blue: 1.0) // #80B3FF
    static let moodAngry = Color(red: 1.0, green: 0.5, blue: 0.5) // #FF8080
    static let moodWorried = Color(red: 0.8, green: 0.6, blue: 1.0) // #CC99FF
    static let moodCalm = Color(red: 0.95, green: 0.75, blue: 0.30) // #F2BF4C
    // 灰色/黑色/白色
    static let grayText = Color.grayText
    static let grayLight = Color(white: 0.95)
    static let black = Color.black
    static let white = Color.white
    // 背景色
    static let cardBackground = Color.white
    static let backgroundLight = AppColors.backgroundLight // #FEEFA7
    // 透明度變化
    static func orangeOpacity(_ value: Double) -> Color {
        orangeMain.opacity(value)
    }
    static func brownOpacity(_ value: Double) -> Color {
        brownDeep.opacity(value)
    }
    static func yellowOpacity(_ value: Double) -> Color {
        yellowMain.opacity(value)
    }
    // 漸層
    static let reminderGradient = LinearGradient(
        gradient: Gradient(colors: [yellowAccent, orange.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
