import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: GameViewModel

    private let tint = Tint.sun

    private var upcomingText: String {
        "Yakında: " + CategoryPack.upcoming.map(\.title).joined(separator: ", ")
    }

    var body: some View {
        ZStack {
            BlobBackground(base: tint.fill, blobs: [
                Blob(color: Tint.rose.fill, diameter: 190, anchor: .bottomTrailing, offset: CGSize(width: 30, height: 30)),
                Blob(color: Tint.teal.fill, diameter: 110, anchor: .bottomLeading, offset: CGSize(width: -10, height: 40))
            ])

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    header

                    ForEach(Array(CategoryPack.available.enumerated()), id: \.element.id) { index, pack in
                        Button {
                            viewModel.selectCategory(pack)
                        } label: {
                            PackBar(pack: pack)
                        }
                        .buttonStyle(PressableStyle())
                        .padding(.leading, index.isMultiple(of: 2) ? 0 : 28)
                        .padding(.trailing, index.isMultiple(of: 2) ? 28 : 0)
                    }

                    if !CategoryPack.upcoming.isEmpty {
                        Text(upcomingText)
                            .font(.rounded(.footnote, weight: .semibold))
                            .foregroundStyle(tint.onMuted)
                            .padding(.top, 6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
            .scrollClipDisabled()
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Pandu")
                    .font(.rounded(.headline, weight: .heavy))
                    .foregroundStyle(tint.onMuted)
                VStack(alignment: .leading, spacing: -12) {
                    Text("Hangi")
                    Text("paket?")
                }
                .font(.display(54))
                .foregroundStyle(tint.on)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
            }
            .padding(.top, 8)

            Spacer(minLength: 8)

            PandaBadge(size: 104, background: .clear)
                .background {
                    Circle()
                        .fill(Tint.indigo.fill)
                        .frame(width: 230, height: 230)
                        .offset(x: 34, y: -44)
                }
                .padding(.top, 6)
        }
        .padding(.bottom, 10)
    }
}

/// Bir paketi kendi renginde, boydan boya bir çubuk olarak gösterir.
private struct PackBar: View {
    let pack: CategoryPack

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: pack.icon)
                .font(.title3.weight(.bold))
                .frame(width: 30)
                .accessibilityHidden(true)
            Text(pack.title)
                .font(.rounded(.title2, weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer(minLength: 8)
            Text("\(pack.cardCount)")
                .font(.rounded(.subheadline, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(pack.tint.onMuted)
                .accessibilityLabel("\(pack.cardCount) kart")
        }
        .foregroundStyle(pack.tint.on)
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(pack.tint.fill, in: Capsule())
        .contentShape(Capsule())
        .accessibilityElement(children: .combine)
    }
}
