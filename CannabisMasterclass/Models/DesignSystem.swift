import Foundation
import Combine

// MARK: - Design System (nui.css tokens)

enum DesignSystem {
    // MARK: - Brand Colors (Cannabis Green Theme)
    static let green500 = "3D6B4F"
    static let green400 = "4A7D5E"
    static let green600 = "2D5A3F"
    static let green700 = "1F4A32"
    static let purple500 = "7F77DD"
    static let purple400 = "9690E5"
    static let orange500 = "C8831A"
    static let orange400 = "D99B3C"
    static let red500 = "D94452"
    static let red400 = "E5616E"
    static let blue500 = "3B82F6"

    // MARK: - Theme Colors
    static let bgPrimary = "121212"
    static let bgSecondary = "1E1E1E"
    static let bgCard = "1A1A1A"
    static let bgCardElevated = "222222"
    static let textPrimary = "FFFFFF"
    static let textSecondary = "A0A0A0"
    static let textTertiary = "666666"
    static let border = "2A2A2A"

    // MARK: - Spacing
    static let spacingXs: CGFloat = 4
    static let spacingSm: CGFloat = 8
    static let spacingMd: CGFloat = 12
    static let spacingLg: CGFloat = 16
    static let spacingXl: CGFloat = 24
    static let spacing2xl: CGFloat = 32

    // MARK: - Corner Radius
    static let radiusSm: CGFloat = 8
    static let radiusMd: CGFloat = 12
    static let radiusLg: CGFloat = 16
    static let radiusXl: CGFloat = 20
    static let radiusFull: CGFloat = 999

    // MARK: - Font Sizes
    static let textXs: CGFloat = 11
    static let textSm: CGFloat = 13
    static let textMd: CGFloat = 15
    static let textLg: CGFloat = 18
    static let textXl: CGFloat = 22
    static let text2xl: CGFloat = 28
    static let text3xl: CGFloat = 36
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }

    static let brandGreen = Color(hex: "3D6B4F")
    static let brandGreenLight = Color(hex: "4A7D5E")
    static let brandPurple = Color(hex: "7F77DD")
    static let brandOrange = Color(hex: "C8831A")
    static let brandRed = Color(hex: "D94452")
    static let nuiBg = Color(hex: "121212")
    static let nuiCard = Color(hex: "1A1A1A")
    static let nuiCardElevated = Color(hex: "222222")
    static let nuiBorder = Color(hex: "2A2A2A")
    static let nuiSecondaryText = Color(hex: "A0A0A0")
}

// MARK: - Gradient

enum NuiGradients {
    static let green = LinearGradient(
        colors: [Color(hex: "2D5A3F"), Color(hex: "3D6B4F")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let purple = LinearGradient(
        colors: [Color(hex: "5B54C4"), Color(hex: "7F77DD")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let orange = LinearGradient(
        colors: [Color(hex: "A06815"), Color(hex: "C8831A")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func goalGradient(_ goal: GrowGoal) -> LinearGradient {
        switch goal {
        case .A: return green
        case .B: return purple
        case .C: return orange
        }
    }
}
