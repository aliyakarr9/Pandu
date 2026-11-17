import SwiftUI
import UIKit

/// Bir paketin ya da takımın renk ailesi: dolgu, üstündeki yazı ve koyu tonu.
struct Tint: Equatable {
    let fill: Color
    let on: Color
    let onMuted: Color
    let deep: Color
    let onDeep: Color
    /// Zeminle zıtlaşan süs rengi; arka plandaki dairelerde kullanılır.
    let pop: Color

    init(fill: UInt32, on: UInt32, onMuted: UInt32, deep: UInt32, onDeep: UInt32 = 0xFFFFFF, pop: UInt32 = 0xFFD23F) {
        self.fill = Color(hex: fill)
        self.on = Color(hex: on)
        self.onMuted = Color(hex: onMuted)
        self.deep = Color(hex: deep)
        self.onDeep = Color(hex: onDeep)
        self.pop = Color(hex: pop)
    }
}

extension Tint {
    static let indigo = Tint(fill: 0x5B4FCF, on: 0xFFFFFF, onMuted: 0xDAD6F8, deep: 0x362D93, pop: 0xF2A01E)
    static let amber = Tint(fill: 0xF2A01E, on: 0x3A2400, onMuted: 0x6B4500, deep: 0x8F5600, pop: 0x5B4FCF)
    static let sun = Tint(fill: 0xFFD23F, on: 0x3A2400, onMuted: 0x6B4E00, deep: 0xC28F00, pop: 0x5B4FCF)
    static let brown = Tint(fill: 0x8B5A2B, on: 0xFFFFFF, onMuted: 0xF0DEC9, deep: 0x55351A)
    static let green = Tint(fill: 0x23924A, on: 0xFFFFFF, onMuted: 0xD3F0DC, deep: 0x145C2E)
    static let teal = Tint(fill: 0x0E7C86, on: 0xFFFFFF, onMuted: 0xCFEDEF, deep: 0x084C53)
    static let rose = Tint(fill: 0xCF4B79, on: 0xFFFFFF, onMuted: 0xFAD9E4, deep: 0x852A4A)
    static let coral = Tint(fill: 0xD9532C, on: 0xFFFFFF, onMuted: 0xFBDCD2, deep: 0x8A2F14)
    static let blue = Tint(fill: 0x2B7BD6, on: 0xFFFFFF, onMuted: 0xD5E6FA, deep: 0x17498A)
}

enum Theme {
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let ink = Color(hex: 0x1D1D1F)
    static let pandaBadge = Color(hex: 0xDDEBC8)
    static let crown = Color(hex: 0xFFD84D)

    static let correct = Color(hex: 0x1F9D55)
    static let taboo = Color(hex: 0xD93F3F)
    static let pass = Color(hex: 0x6E6E73)

    enum Radius {
        static let tile: CGFloat = 20
        static let card: CGFloat = 28
        static let control: CGFloat = 18
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

extension Font {
    /// Başlık ve sayılar için yuvarlak sistem yazısı; yazı boyutu ayarına uyar.
    static func rounded(_ style: Font.TextStyle, weight: Font.Weight = .bold) -> Font {
        .system(style, design: .rounded, weight: weight)
    }

    /// Ekranın en büyük sözü için dev, kalın yuvarlak yazı.
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .heavy, design: .rounded)
    }
}
