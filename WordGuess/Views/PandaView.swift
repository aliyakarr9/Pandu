import SwiftUI

/// Pandu'nun maskotu. Şekillerle çizilir; her boyutta net kalır ve ifadesi değişebilir.
struct PandaView: View {
    enum Mood {
        case calm
        case happy
        case shocked
        case asleep
    }

    var mood: Mood = .calm
    var crowned = false

    @State private var isBlinking = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var headroom: CGFloat { crowned ? 7 : 0 }

    var body: some View {
        let face = mood
        let eyesClosed = isBlinking || face == .asleep
        let hasCrown = crowned
        let top = headroom
        let ink = Theme.ink
        let crownColor = Theme.crown

        Canvas { context, size in
            let boxHeight = 44 + top
            let unit = min(size.width / 48, size.height / boxHeight)
            context.translateBy(
                x: (size.width - 48 * unit) / 2,
                y: (size.height - boxHeight * unit) / 2 + top * unit
            )
            context.scaleBy(x: unit, y: unit)

            let inkShade = GraphicsContext.Shading.color(ink)
            let white = GraphicsContext.Shading.color(.white)

            for x in [10.0, 38.0] {
                context.fill(Path(ellipseIn: CGRect(x: x - 8, y: 1, width: 16, height: 16)), with: inkShade)
            }

            let head = Path(ellipseIn: CGRect(x: 4, y: 7, width: 40, height: 36))
            context.fill(head, with: white)
            context.stroke(head, with: inkShade, lineWidth: 1)

            for (x, degrees) in [(15.0, 18.0), (33.0, -18.0)] {
                let transform = CGAffineTransform(translationX: x, y: 23).rotated(by: degrees * .pi / 180)
                let patch = Path(ellipseIn: CGRect(x: -5.5, y: -6.5, width: 11, height: 13)).applying(transform)
                context.fill(patch, with: inkShade)
            }

            let lidStyle = StrokeStyle(lineWidth: 1.2, lineCap: .round)
            for x in [16.0, 32.0] {
                if eyesClosed {
                    var lid = Path()
                    lid.move(to: CGPoint(x: x - 2.2, y: 22))
                    lid.addQuadCurve(to: CGPoint(x: x + 2.2, y: 22), control: CGPoint(x: x, y: 24))
                    context.stroke(lid, with: white, style: lidStyle)
                } else if face == .happy {
                    var arc = Path()
                    arc.move(to: CGPoint(x: x - 2.3, y: 23))
                    arc.addQuadCurve(to: CGPoint(x: x + 2.3, y: 23), control: CGPoint(x: x, y: 19.8))
                    context.stroke(arc, with: white, style: lidStyle)
                } else if face == .shocked {
                    context.fill(Path(ellipseIn: CGRect(x: x - 2.8, y: 19.2, width: 5.6, height: 5.6)), with: white)
                    context.fill(Path(ellipseIn: CGRect(x: x - 0.9, y: 21.1, width: 1.8, height: 1.8)), with: inkShade)
                } else {
                    context.fill(Path(ellipseIn: CGRect(x: x - 1.8, y: 20.2, width: 3.6, height: 3.6)), with: white)
                }
            }

            context.fill(Path(ellipseIn: CGRect(x: 21.4, y: 29.2, width: 5.2, height: 3.6)), with: inkShade)

            let mouthStyle = StrokeStyle(lineWidth: 0.9, lineCap: .round, lineJoin: .round)
            switch face {
            case .happy:
                var mouth = Path()
                mouth.move(to: CGPoint(x: 20.4, y: 34.4))
                mouth.addQuadCurve(to: CGPoint(x: 27.6, y: 34.4), control: CGPoint(x: 24, y: 40))
                mouth.closeSubpath()
                context.fill(mouth, with: inkShade)
            case .shocked:
                context.fill(Path(ellipseIn: CGRect(x: 22.3, y: 33.6, width: 3.4, height: 4.2)), with: inkShade)
            case .asleep:
                var mouth = Path()
                mouth.move(to: CGPoint(x: 22.6, y: 35.4))
                mouth.addLine(to: CGPoint(x: 25.4, y: 35.4))
                context.stroke(mouth, with: inkShade, style: mouthStyle)
            case .calm:
                var mouth = Path()
                mouth.move(to: CGPoint(x: 21, y: 34.4))
                mouth.addQuadCurve(to: CGPoint(x: 24, y: 34.8), control: CGPoint(x: 22.5, y: 36.8))
                mouth.addQuadCurve(to: CGPoint(x: 27, y: 34.4), control: CGPoint(x: 25.5, y: 36.8))
                context.stroke(mouth, with: inkShade, style: mouthStyle)
            }

            if hasCrown {
                var crown = Path()
                crown.move(to: CGPoint(x: 16, y: 8.5))
                crown.addLine(to: CGPoint(x: 14.5, y: -3))
                crown.addLine(to: CGPoint(x: 20, y: 2.5))
                crown.addLine(to: CGPoint(x: 24, y: -6))
                crown.addLine(to: CGPoint(x: 28, y: 2.5))
                crown.addLine(to: CGPoint(x: 33.5, y: -3))
                crown.addLine(to: CGPoint(x: 32, y: 8.5))
                crown.closeSubpath()
                context.fill(crown, with: .color(crownColor))
                context.stroke(crown, with: inkShade, style: StrokeStyle(lineWidth: 0.9, lineJoin: .round))
            }
        }
        .aspectRatio(48 / (44 + headroom), contentMode: .fit)
        .accessibilityHidden(true)
        .task(id: mood) {
            guard !reduceMotion, mood != .asleep else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Double.random(in: 2.5...5)))
                if Task.isCancelled { break }
                isBlinking = true
                try? await Task.sleep(for: .milliseconds(130))
                isBlinking = false
            }
        }
    }
}

/// Nötr zeminlerde pandayı taşıyan yuvarlak rozet. Dokununca panda sevinir.
struct PandaBadge: View {
    var size: CGFloat = 52
    var background: Color = Theme.pandaBadge

    @State private var mood: PandaView.Mood = .calm

    var body: some View {
        PandaView(mood: mood)
            .padding(size * 0.14)
            .frame(width: size, height: size)
            .background(background, in: Circle())
            .scaleEffect(mood == .happy ? 1.08 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: mood)
            .onTapGesture {
                guard mood == .calm else { return }
                mood = .happy
                Task {
                    try? await Task.sleep(for: .seconds(1.2))
                    mood = .calm
                }
            }
    }
}
