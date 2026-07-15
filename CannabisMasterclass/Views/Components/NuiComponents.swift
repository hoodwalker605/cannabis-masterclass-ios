import SwiftUI

// MARK: - Reusable Components

struct NuiCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Color.nuiCard)
            .cornerRadius(DesignSystem.radiusLg)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radiusLg)
                    .stroke(Color.nuiBorder, lineWidth: 1)
            )
    }
}

struct NuiButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void

    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
    }

    init(title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: {
            Haptics.light()
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Text(icon)
                }
                Text(title)
                    .font(.system(size: DesignSystem.textMd, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(backgroundStyle)
            .foregroundColor(foregroundStyle)
            .cornerRadius(DesignSystem.radiusMd)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.radiusMd)
                    .stroke(borderStyle, lineWidth: style == .outline ? 1.5 : 0)
            )
        }
    }

    var backgroundStyle: some ShapeStyle {
        switch style {
        case .primary: return Color.brandGreen
        case .secondary: return Color.nuiCardElevated
        case .outline: return Color.clear
        case .ghost: return Color.clear
        }
    }

    var foregroundStyle: Color {
        switch style {
        case .primary, .secondary: return .white
        case .outline: return Color.brandGreen
        case .ghost: return .white
        }
    }

    var borderStyle: Color {
        switch style {
        case .outline: return Color.brandGreen
        default: return .clear
        }
    }
}

struct NuiSectionHeader: View {
    let title: String
    let icon: String?

    init(_ title: String, icon: String? = nil) {
        self.title = title
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Text(icon)
                    .font(.title3)
            }
            Text(title)
                .font(.system(size: DesignSystem.textLg, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NuiBadge: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = Color.brandGreen) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: DesignSystem.textXs, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .cornerRadius(DesignSystem.radiusSm)
    }
}

struct NuiEmptyState: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 48))
            Text(title)
                .font(.system(size: DesignSystem.textLg, weight: .bold))
                .foregroundColor(.white)
            Text(message)
                .font(.system(size: DesignSystem.textMd))
                .foregroundColor(.nuiSecondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct NuiGauge: View {
    let value: Double
    let max: Double
    let color: Color
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(Color.nuiBorder, lineWidth: 6)
                Circle()
                    .trim(from: 0, to: CGFloat(min(value / max, 1.0)))
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(label)
                    .font(.system(size: DesignSystem.textSm, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)
        }
    }
}

struct NuiProgress: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.nuiBorder)
                    .frame(height: 4)
                    .cornerRadius(2)
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(min(progress, 1.0)), height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
}
