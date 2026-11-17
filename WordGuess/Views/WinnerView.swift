import SwiftUI
import UIKit

struct WinnerView: View {
    @ObservedObject var viewModel: GameViewModel
    let winner: Team
    /// Oyun bittiği andaki skorlar; ekran kapanırken sıfırlanmış görünmesin diye sabitlenir.
    let teams: [Team]

    @State private var hasAppeared = false
    /// Son doğruya hızlı basan parmak kazanan ekranını yanlışlıkla geçmesin diye kısa bir bekleme.
    @State private var isArmed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var tint: Tint { winner.tint }

    var body: some View {
        ZStack {
            BlobBackground(base: tint.fill, blobs: [
                Blob(color: tint.pop, diameter: 150, anchor: .topLeading, offset: CGSize(width: 20, height: 90)),
                Blob(color: tint.deep, diameter: 210, anchor: .bottomTrailing, offset: CGSize(width: 10, height: -170))
            ])

            VStack(spacing: 0) {
                Spacer(minLength: 12)

                PandaView(mood: .happy, crowned: true)
                    .frame(width: 150)
                    .background {
                        Circle()
                            .fill(tint.deep)
                            .frame(width: 260, height: 260)
                            .offset(y: 10)
                    }
                    .scaleEffect(hasAppeared ? 1 : 0.6)
                    .rotationEffect(.degrees(hasAppeared ? 4 : -10))

                Text(winner.name)
                    .font(.display(56))
                    .foregroundStyle(tint.on)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .padding(.top, 70)
                    .accessibilityAddTraits(.isHeader)
                Text("kazandı!")
                    .font(.display(34))
                    .foregroundStyle(tint.onMuted)

                HStack(alignment: .top, spacing: 20) {
                    ForEach(teams) { team in
                        ScoreBubble(team: team, isHighlighted: team.id == winner.id, nameColor: tint.on)
                    }
                }
                .padding(.top, 22)

                Spacer(minLength: 12)

                Button("Tekrar oyna") {
                    viewModel.rematch()
                }
                .buttonStyle(FilledButtonStyle(fill: .white, on: tint.deep))

                Button("Paket değiştir") {
                    viewModel.quitGame()
                    viewModel.returnToCategories()
                }
                .font(.rounded(.body, weight: .bold))
                .foregroundStyle(tint.on)
                .frame(minHeight: 48)
                .padding(.top, 4)
            }
            .allowsHitTesting(isArmed)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .frame(maxWidth: 520)

            if !reduceMotion {
                ConfettiView(colors: [.white, Tint.sun.fill, Tint.rose.fill, Tint.green.fill, tint.pop])
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1200))
            isArmed = true
        }
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            if reduceMotion {
                hasAppeared = true
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) {
                    hasAppeared = true
                }
            }
        }
    }
}
