import SwiftUI

// MARK: - Ortak Kontrol Butonu
struct ControlButton: View {
    let icon: String
    let label: String
    let color: Color
    var isDisabled: Bool = false
    var isLarge: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: isLarge ? 32 : 24, weight: .bold))
                Text(label)
                    .font(.system(size: 12, weight: .black))
            }
            .frame(width: isLarge ? 90 : 75, height: isLarge ? 90 : 75)
            .background(
                ZStack {
                    if isDisabled {
                        Circle().fill(Color.white.opacity(0.1))
                    } else {
                        Circle().fill(color.opacity(0.15))
                        Circle().stroke(color.opacity(0.4), lineWidth: 2)
                    }
                }
            )
            .foregroundColor(isDisabled ? .white.opacity(0.2) : color)
        }
        .disabled(isDisabled)
    }
}

// MARK: - Ortak Swipe Gösterge İkonu
struct SwipeIndicatorIcon: View {
    let icon: String
    let color: Color
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 80))
            .foregroundColor(color)
            .shadow(color: color.opacity(0.5), radius: 20)
            .opacity(0.8)
    }
}

// MARK: - Hex Renk Desteği
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
