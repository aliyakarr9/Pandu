import SwiftUI

struct CardView: View {
    let card: WordCard

    @ScaledMetric(relativeTo: .largeTitle) private var wordSize: CGFloat = 44

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Circle()
                    .fill(card.difficultyColor)
                    .frame(width: 8, height: 8)
                Text("\(card.difficultyLabel) · \(card.pointValue) puan")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            Text(card.word)
                .font(.system(size: wordSize, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .padding(.top, 10)

            Divider()
                .padding(.vertical, 22)

            Label("Yasaklı kelimeler", systemImage: "nosign")
                .font(.footnote.weight(.medium))
                .foregroundStyle(Theme.taboo)
                .padding(.bottom, 14)

            VStack(spacing: 14) {
                ForEach(Array(card.forbiddenWords.enumerated()), id: \.offset) { _, word in
                    Text(word)
                        .font(.rounded(.title2, weight: .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous))
        .compositingGroup()
        .shadow(color: .black.opacity(0.14), radius: 16, y: 8)
        .accessibilityElement(children: .combine)
    }
}
