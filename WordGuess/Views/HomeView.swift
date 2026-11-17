import SwiftUI

/// Oyun kurulumu: seçili paket, takım adları ve kurallar.
struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel

    private let unlimitedPasses = 11
    private let maxNameLength = 16

    private var pack: CategoryPack {
        viewModel.selectedCategory ?? CategoryPack.allCategories[0]
    }

    private var tint: Tint { pack.tint }

    private var roundTime: Binding<Int> {
        Binding(
            get: { viewModel.settings.roundTime },
            set: {
                viewModel.settings.roundTime = $0
                viewModel.saveSettings()
            }
        )
    }

    private var targetScore: Binding<Int> {
        Binding(
            get: { viewModel.settings.targetScore },
            set: {
                viewModel.settings.targetScore = $0
                viewModel.saveSettings()
            }
        )
    }

    private var passCount: Binding<Int> {
        Binding(
            get: { viewModel.settings.maxPassCount < 0 ? unlimitedPasses : viewModel.settings.maxPassCount },
            set: {
                viewModel.settings.maxPassCount = $0 >= unlimitedPasses ? -1 : $0
                viewModel.saveSettings()
            }
        )
    }

    private var passText: String {
        viewModel.settings.maxPassCount < 0 ? "Sınırsız" : "\(viewModel.settings.maxPassCount)"
    }

    var body: some View {
        ZStack {
            BlobBackground(base: tint.fill, blobs: [
                Blob(color: tint.deep, diameter: 260, anchor: .topTrailing, offset: CGSize(width: -30, height: 70)),
                Blob(color: tint.pop, diameter: 150, anchor: .bottomLeading, offset: CGSize(width: 20, height: -70))
            ])

            VStack(spacing: 0) {
                header

                Form {
                    Section {
                        ForEach(viewModel.teams.indices, id: \.self) { index in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(viewModel.teams[index].tint.fill)
                                    .frame(width: 14, height: 14)
                                    .accessibilityHidden(true)
                                TextField("\(index + 1). Takım", text: $viewModel.teams[index].name)
                                    .font(.rounded(.body, weight: .semibold))
                                    .submitLabel(.done)
                                    .autocorrectionDisabled()
                                    .onChange(of: viewModel.teams[index].name) { _, name in
                                        if name.count > maxNameLength {
                                            viewModel.teams[index].name = String(name.prefix(maxNameLength))
                                        }
                                    }
                            }
                        }
                    } header: {
                        sectionTitle("Takımlar")
                    }

                    Section {
                        Stepper(value: roundTime, in: 30...120, step: 10) {
                            LabeledContent("Süre", value: "\(viewModel.settings.roundTime) sn")
                        }
                        Stepper(value: targetScore, in: 10...100, step: 5) {
                            LabeledContent("Hedef", value: "\(viewModel.settings.targetScore) puan")
                        }
                        Stepper(value: passCount, in: 0...unlimitedPasses) {
                            LabeledContent("Pas hakkı", value: passText)
                        }
                    } header: {
                        sectionTitle("Kurallar")
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .tint(tint.fill)
            }
            .frame(maxWidth: 560)
        }
        .safeAreaInset(edge: .bottom) {
            Button("Oyunu başlat") {
                viewModel.startGame()
            }
            .buttonStyle(FilledButtonStyle(fill: .white, on: tint.deep))
            .disabled(viewModel.isDeckEmpty)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: 560)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.rounded(.headline, weight: .heavy))
            .foregroundStyle(tint.on)
            .textCase(nil)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                viewModel.returnToCategories()
            } label: {
                Label("Paketler", systemImage: "chevron.left")
                    .font(.rounded(.body, weight: .bold))
                    .foregroundStyle(tint.onMuted)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressableStyle())

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(pack.title)
                        .font(.display(52))
                        .foregroundStyle(tint.on)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .accessibilityAddTraits(.isHeader)
                    Text("\(pack.desc) \(pack.cardCount) kart.")
                        .font(.rounded(.subheadline, weight: .semibold))
                        .foregroundStyle(tint.onMuted)
                }
                Spacer(minLength: 12)
                Image(systemName: pack.icon)
                    .font(.system(size: 54, weight: .bold))
                    .foregroundStyle(tint.onDeep)
                    .frame(width: 96, height: 96)
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
