import SwiftUI

/// Arka plandaki büyük, düz renkli dairelerden biri.
struct Blob {
    let color: Color
    let diameter: CGFloat
    /// Dairenin merkezi; ekranın oranı olarak (0,0 sol üst, 1,1 sağ alt).
    let anchor: UnitPoint
    var offset: CGSize = .zero
}

/// Düz bir zemin ve üstünde büyük daireler. Ekran açılırken daireler yaylanarak büyür.
struct BlobBackground: View {
    let base: Color
    let blobs: [Blob]

    @State private var hasAppeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                base
                ForEach(blobs.indices, id: \.self) { index in
                    let blob = blobs[index]
                    Circle()
                        .fill(blob.color)
                        .frame(width: blob.diameter, height: blob.diameter)
                        .scaleEffect(hasAppeared || reduceMotion ? 1 : 0.6)
                        .position(
                            x: geometry.size.width * blob.anchor.x + blob.offset.width,
                            y: geometry.size.height * blob.anchor.y + blob.offset.height
                        )
                        .animation(
                            .spring(response: 0.55, dampingFraction: 0.7).delay(Double(index) * 0.07),
                            value: hasAppeared
                        )
                }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
        .onAppear { hasAppeared = true }
    }
}

/// Bir takımın skorunu kendi renginde, beyaz çerçeveli bir balonda gösterir.
struct ScoreBubble: View {
    let team: Team
    var isHighlighted = true
    var nameColor: Color = .white

    var body: some View {
        VStack(spacing: 8) {
            Text("\(team.score)")
                .font(.display(38))
                .monospacedDigit()
                .minimumScaleFactor(0.6)
                .contentTransition(.numericText())
                .foregroundStyle(team.tint.on)
                .frame(width: 96, height: 96)
                .background(team.tint.fill, in: Circle())
                .overlay(Circle().strokeBorder(.white, lineWidth: 4))
                .scaleEffect(isHighlighted ? 1 : 0.86)
            Text(team.name)
                .font(.rounded(.subheadline, weight: .semibold))
                .foregroundStyle(nameColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: 130)
        .accessibilityElement(children: .combine)
    }
}
