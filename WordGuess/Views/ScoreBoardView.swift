import SwiftUI

/// Turlar arasındaki sıra devri: kim oynayacak, skor ne durumda.
struct ScoreBoardView: View {
    @ObservedObject var viewModel: GameViewModel

    @State private var showQuitConfirm = false
    @State private var hasAppeared = false
    /// Tur biterken hızlı hızlı basan parmak yanlışlıkla yeni turu başlatmasın diye kısa bir bekleme.
    @State private var isArmed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var team: Team { viewModel.currentTeam }
    private var tint: Tint { team.tint }

    var body: some View {
        ZStack {
            BlobBackground(base: tint.fill, blobs: [
                Blob(color: tint.pop, diameter: 130, anchor: .topTrailing, offset: CGSize(width: 10, height: 250)),
                Blob(color: tint.deep, diameter: 180, anchor: .bottomLeading, offset: CGSize(width: -50, height: -150))
            ])

            VStack(spacing: 0) {
                HStack {
                    CircleIconButton(symbol: "xmark", label: "Oyunu bitir", tint: tint) {
                        showQuitConfirm = true
                    }
                    Spacer()
                    CircleIconButton(symbol: "questionmark", label: "Nasıl oynanır", tint: tint) {
                        viewModel.showRulesCard = true
                    }
                }

                Spacer(minLength: 8)

                PandaView(mood: .happy)
                    .frame(width: 140)
                    .background {
                        Circle()
                            .fill(tint.deep)
                            .frame(width: 250, height: 250)
                    }
                    .scaleEffect(hasAppeared ? 1 : 0.7)
                    .rotationEffect(.degrees(hasAppeared ? -4 : 8))

                Text("Sıra sizde")
                    .font(.rounded(.headline, weight: .heavy))
                    .foregroundStyle(tint.onMuted)
                    .padding(.top, 74)
                Text(team.name)
                    .font(.display(56))
                    .foregroundStyle(tint.on)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .accessibilityAddTraits(.isHeader)
                Text("Telefonu anlatıcıya ver")
                    .font(.rounded(.body, weight: .semibold))
                    .foregroundStyle(tint.onMuted)

                Spacer(minLength: 8)

                HStack(alignment: .top, spacing: 20) {
                    ForEach(viewModel.teams) { item in
                        ScoreBubble(team: item, isHighlighted: item.id == team.id, nameColor: tint.on)
                    }
                }

                Text(footnote)
                    .font(.rounded(.footnote, weight: .semibold))
                    .foregroundStyle(tint.onMuted)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                Button("Turu başlat") {
                    viewModel.startRound()
                }
                .buttonStyle(FilledButtonStyle(fill: .white, on: tint.deep))
                .allowsHitTesting(isArmed)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .frame(maxWidth: 520)
        }
        .onAppear {
            if reduceMotion {
                hasAppeared = true
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    hasAppeared = true
                }
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(900))
            isArmed = true
        }
        .sheet(isPresented: $viewModel.showRulesCard, onDismiss: viewModel.markRulesSeen) {
            RulesSheet()
        }
        .confirmationDialog("Oyun bitsin mi?", isPresented: $showQuitConfirm, titleVisibility: .visible) {
            Button("Oyunu bitir", role: .destructive) {
                viewModel.quitGame()
            }
            Button("Vazgeç", role: .cancel) {}
        } message: {
            Text("Skorlar silinir.")
        }
    }

    private var footnote: String {
        let target = "Hedef \(viewModel.settings.targetScore) puan."
        guard let last = viewModel.lastRound else { return target }
        let summary: String
        if last.score > 0 {
            summary = "\(last.teamName) bu turda \(last.score) puan topladı."
        } else if last.score < 0 {
            summary = "\(last.teamName) bu turda \(-last.score) puan kaybetti."
        } else {
            summary = "\(last.teamName) bu turda puan alamadı."
        }
        return summary + " " + target
    }
}
