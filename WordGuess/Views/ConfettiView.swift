import SwiftUI

/// Kazanan ekranında bir kez yağan konfeti. Birkaç saniye sonra kendini kaldırır.
struct ConfettiView: View {
    let colors: [Color]

    @State private var start = Date()
    @State private var pieces = Piece.burst(count: 70)
    @State private var isFinished = false

    private let duration: TimeInterval = 4.5

    var body: some View {
        if !isFinished {
            let palette = colors
            let confetti = pieces
            let startDate = start
            let total = duration

            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                Canvas { context, size in
                    for piece in confetti {
                        let time = elapsed - piece.delay
                        guard time > 0 else { continue }
                        let x = size.width * piece.startX + piece.drift * time + sin(time * 3 + piece.phase) * 10
                        let y = -20 + piece.fall * time + 70 * time * time
                        guard y < size.height + 20 else { continue }

                        var local = context
                        local.opacity = min(1, max(0, (total - elapsed) / 0.8))
                        local.translateBy(x: x, y: y)
                        local.rotate(by: .radians(time * piece.spin))
                        let rect = CGRect(x: -piece.size / 2, y: -piece.size / 4, width: piece.size, height: piece.size / 2)
                        local.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(palette[piece.colorIndex % palette.count]))
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .task {
                try? await Task.sleep(for: .seconds(duration))
                isFinished = true
            }
        }
    }

    struct Piece {
        let startX: Double
        let delay: Double
        let drift: Double
        let fall: Double
        let spin: Double
        let phase: Double
        let size: Double
        let colorIndex: Int

        static func burst(count: Int) -> [Piece] {
            (0..<count).map { index in
                Piece(
                    startX: .random(in: 0...1),
                    delay: .random(in: 0...0.9),
                    drift: .random(in: -30...30),
                    fall: .random(in: 110...260),
                    spin: .random(in: -6...6),
                    phase: .random(in: 0...6),
                    size: .random(in: 8...13),
                    colorIndex: index
                )
            }
        }
    }
}
