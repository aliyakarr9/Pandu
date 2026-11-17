import SwiftUI

/// Kurallar. İlk oyunda kendiliğinden açılır, sonra soru işaretinden.
struct RulesSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Nasıl oynanır")
                    .font(.rounded(.title2))
                    .accessibilityAddTraits(.isHeader)

                Text("Anlatıcı kartın üstündeki kelimeyi, altındaki yasaklı kelimeleri söylemeden takımına anlatır.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 18) {
                    RuleRow(symbol: "checkmark", color: Theme.correct, title: "Doğru",
                            detail: "Kartın puanını alırsın: kolay 1, orta 2, zor 3 puan.")
                    RuleRow(symbol: "hand.raised.fill", color: Theme.taboo, title: "Tabu",
                            detail: "Yasaklı kelime söylenirse 1 puan gider.")
                    RuleRow(symbol: "arrow.uturn.right", color: Theme.pass, title: "Pas",
                            detail: "Puan değişmez. Pas hakkını kurulumda belirlersin.")
                    RuleRow(symbol: "hand.draw.fill", color: Theme.pass, title: "Kaydırarak da oynanır",
                            detail: "Kartı sağa atarsan doğru, sola pas, aşağı tabu.")
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .safeAreaInset(edge: .bottom) {
            Button("Anladım") {
                dismiss()
            }
            .buttonStyle(FilledButtonStyle(.indigo))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Theme.surface)
        }
        .presentationBackground(Theme.surface)
        .presentationDetents([.fraction(0.72), .large])
        .presentationDragIndicator(.visible)
    }
}

private struct RuleRow: View {
    let symbol: String
    let color: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Image(systemName: symbol)
                .font(.body.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 26)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.rounded(.headline))
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
