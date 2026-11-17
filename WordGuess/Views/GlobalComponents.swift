import SwiftUI

/// Basıldığı anda hafifçe küçülen düğme; geri bildirim parmak inerken başlar.
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isPressed)
    }
}

/// Ekranın ana eylemi için tam genişlikte dolu düğme.
struct FilledButtonStyle: ButtonStyle {
    let fill: Color
    let on: Color

    @Environment(\.isEnabled) private var isEnabled

    init(fill: Color, on: Color) {
        self.fill = fill
        self.on = on
    }

    init(_ tint: Tint) {
        self.init(fill: tint.fill, on: tint.on)
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.rounded(.title3, weight: .heavy))
            .foregroundStyle(on)
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(fill, in: Capsule())
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isPressed)
    }
}

/// Renkli zemin üstünde duran yuvarlak ikon düğmesi.
struct CircleIconButton: View {
    let symbol: String
    let label: String
    let tint: Tint
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(tint.on)
                .frame(width: 44, height: 44)
                .background(tint.deep.opacity(0.22), in: Circle())
        }
        .buttonStyle(PressableStyle())
        .accessibilityLabel(label)
    }
}
