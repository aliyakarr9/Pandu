import SwiftUI

/// Kartın bir turdaki üç sonucu.
enum Swipe {
    case correct
    case pass
    case taboo

    var title: String {
        switch self {
        case .correct: return "Doğru"
        case .pass:    return "Pas"
        case .taboo:   return "Tabu"
        }
    }

    var symbol: String {
        switch self {
        case .correct: return "checkmark"
        case .pass:    return "arrow.uturn.right"
        case .taboo:   return "hand.raised.fill"
        }
    }

    var color: Color {
        switch self {
        case .correct: return Theme.correct
        case .pass:    return Theme.pass
        case .taboo:   return Theme.taboo
        }
    }

    /// Kartın ekrandan çıkarken gittiği yön.
    var exit: CGSize {
        switch self {
        case .correct: return CGSize(width: 1100, height: 60)
        case .pass:    return CGSize(width: -1100, height: 60)
        case .taboo:   return CGSize(width: 0, height: 1400)
        }
    }
}

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    @State private var drag: CGSize = .zero
    @State private var flights: [Flight] = []
    @State private var pops: [ScorePop] = []
    @State private var streak = 0
    @State private var reaction: PandaView.Mood?
    @State private var reactionToken = 0
    @State private var showQuitConfirm = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    private let commitDistance: CGFloat = 110
    /// Kartın dururkenki hafif eğimi.
    static let restTilt: Double = -2

    private var tint: Tint { viewModel.currentTeam.tint }
    private var isCritical: Bool { viewModel.timeRemaining <= 10 }

    private var pandaMood: PandaView.Mood {
        reaction ?? (isCritical ? .shocked : .calm)
    }

    var body: some View {
        ZStack {
            BlobBackground(base: tint.fill, blobs: [
                Blob(color: tint.pop, diameter: 110, anchor: .bottomLeading, offset: CGSize(width: -10, height: -150))
            ])

            VStack(spacing: 14) {
                header
                cardArea
                    .frame(maxWidth: 460, maxHeight: 560)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 6)
                actionBar
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 10)
            .frame(maxWidth: 560)

            if viewModel.gameState == .paused {
                pauseOverlay
                    .transition(.opacity)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .animation(.easeOut(duration: 0.2), value: viewModel.gameState)
        .onChange(of: viewModel.timeRemaining) { _, newValue in
            if newValue <= 10 && newValue > 0 {
                GameFX.playTensionBeat()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active && viewModel.gameState == .playing {
                viewModel.pauseGame()
            }
        }
    }

    // MARK: Üst bölüm

    private var header: some View {
        let peak: CGFloat = reduceMotion ? 1 : (isCritical ? 1.16 : 1.03)

        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: -6) {
                Text("\(max(0, viewModel.timeRemaining))")
                    .font(.display(88))
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.snappy(duration: 0.25), value: viewModel.timeRemaining)
                    .keyframeAnimator(initialValue: CGFloat(1), trigger: viewModel.timeRemaining) { content, scale in
                        content.scaleEffect(scale, anchor: .leading)
                    } keyframes: { _ in
                        KeyframeTrack {
                            SpringKeyframe(peak, duration: 0.12)
                            SpringKeyframe(1, duration: 0.3)
                        }
                    }
                Text("saniye")
                    .font(.rounded(.headline, weight: .heavy))
                    .opacity(0.8)
            }
            .foregroundStyle(.white)
            .padding(.leading, 6)
            .background {
                Circle()
                    .fill(isCritical ? Theme.taboo : tint.deep)
                    .frame(width: 250, height: 250)
                    .offset(x: -26, y: -34)
                    .animation(.easeInOut(duration: 0.3), value: isCritical)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Kalan süre \(viewModel.timeRemaining) saniye")

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing: 8) {
                    Text("\(viewModel.roundScore) puan")
                        .font(.rounded(.headline, weight: .heavy))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.snappy(duration: 0.25), value: viewModel.roundScore)
                        .foregroundStyle(tint.deep)
                        .padding(.horizontal, 14)
                        .frame(minHeight: 44)
                        .background(.white, in: Capsule())
                        .overlay(alignment: .bottom) {
                            ForEach(pops) { pop in
                                ScorePopView(pop: pop, floats: !reduceMotion)
                            }
                        }

                    CircleIconButton(symbol: "pause.fill", label: "Duraklat", tint: tint) {
                        viewModel.pauseGame()
                    }
                }
                .zIndex(1)

                PandaView(mood: pandaMood)
                    .frame(width: 52)
                    .frame(width: 76, height: 76)
                    .background(tint.pop, in: Circle())
                    .scaleEffect(reaction == nil ? 1 : 1.12)
                    .rotationEffect(.degrees(reaction == .shocked ? -8 : (reaction == .happy ? 8 : 0)))
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: reaction)
            }
        }
        .zIndex(1)
    }

    // MARK: Kart

    @ViewBuilder
    private var cardArea: some View {
        if viewModel.isDeckEmpty {
            emptyDeck
        } else if let card = viewModel.currentCard {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.card, style: .continuous)
                    .fill(.white.opacity(0.45))
                    .padding(.horizontal, 10)
                    .rotationEffect(.degrees(3))

                CardView(card: card)
                    .overlay(alignment: .top) {
                        if let hint = dragHint {
                            SwipeStamp(swipe: hint.swipe)
                                .opacity(hint.strength)
                                .offset(y: -16)
                        }
                    }
                    .offset(drag)
                    .rotationEffect(.degrees(Self.restTilt + Double(drag.width) / 22))
                    .gesture(dragGesture)
                    .id(card.id)
                    .transition(.asymmetric(
                        insertion: reduceMotion ? .opacity : .scale(scale: 0.9).combined(with: .opacity),
                        removal: .identity
                    ))

                ForEach(flights) { flight in
                    FlyingCard(flight: flight)
                        .transition(.identity)
                }
            }
            .overlay(alignment: .topTrailing) {
                if streak >= 3 {
                    Label("\(streak) üst üste", systemImage: "flame.fill")
                        .font(.rounded(.subheadline, weight: .heavy))
                        .foregroundStyle(Tint.sun.on)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Tint.sun.fill, in: Capsule())
                        .rotationEffect(.degrees(8))
                        .offset(x: 6, y: -16)
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                        .id(streak)
                }
            }
            .animation(.spring(response: 0.32, dampingFraction: 0.7), value: card.id)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: streak)
        } else {
            ProgressView()
                .tint(tint.on)
        }
    }

    private var emptyDeck: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.stack")
                .font(.largeTitle)
            Text("Bu pakette kart yok")
                .font(.rounded(.title3))
            Button("Paketlere dön") {
                viewModel.quitGame()
                viewModel.returnToCategories()
            }
            .buttonStyle(FilledButtonStyle(fill: .white, on: tint.deep))
            .padding(.top, 8)
        }
        .foregroundStyle(tint.on)
        .padding(24)
    }

    /// Sürüklerken hangi sonuca gidildiğini ve ne kadar yaklaşıldığını söyler.
    private var dragHint: (swipe: Swipe, strength: Double)? {
        let horizontal = abs(drag.width) > abs(drag.height)
        let swipe: Swipe
        let distance: CGFloat
        if horizontal {
            if drag.width > 0 {
                swipe = .correct
            } else if !viewModel.isPassLimitReached {
                swipe = .pass
            } else {
                return nil
            }
            distance = abs(drag.width)
        } else if drag.height > 0 {
            swipe = .taboo
            distance = drag.height
        } else {
            return nil
        }
        let strength = Double((distance - 16) / (commitDistance - 16))
        guard strength > 0 else { return nil }
        return (swipe, min(1, strength))
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                var translation = value.translation
                if translation.width < 0 && viewModel.isPassLimitReached {
                    translation.width = -resist(-translation.width)
                }
                if translation.height < 0 {
                    translation.height = -resist(-translation.height)
                }
                drag = translation
            }
            .onEnded { value in
                if let swipe = decision(for: value) {
                    commit(swipe)
                    return
                }
                if value.predictedEndTranslation.width < -commitDistance && viewModel.isPassLimitReached {
                    viewModel.markPass()
                }
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    drag = .zero
                }
            }
    }

    /// Sınıra dayanınca kart parmağı gittikçe daha az izler.
    private func resist(_ distance: CGFloat) -> CGFloat {
        let limit: CGFloat = 320
        return (distance * limit * 0.4) / (limit + 0.4 * distance)
    }

    /// Karar, kartın bırakıldığı yere değil gittiği yere göre verilir.
    private func decision(for value: DragGesture.Value) -> Swipe? {
        let end = value.predictedEndTranslation
        if abs(end.width) > abs(end.height) {
            if end.width > commitDistance && value.translation.width > 0 { return .correct }
            if end.width < -commitDistance && value.translation.width < 0 && !viewModel.isPassLimitReached { return .pass }
        } else if end.height > commitDistance && value.translation.height > 0 {
            return .taboo
        }
        return nil
    }

    private func commit(_ swipe: Swipe) {
        guard viewModel.gameState == .playing, let card = viewModel.currentCard else { return }
        if swipe == .pass && viewModel.isPassLimitReached {
            viewModel.markPass()
            return
        }

        let flight = Flight(card: card, swipe: swipe, start: drag, fades: reduceMotion)
        flights.append(flight)
        drag = .zero

        switch swipe {
        case .correct:
            streak += 1
            addPop("+\(card.pointValue)", fill: Tint.sun.fill, on: Tint.sun.on)
            react(.happy)
            viewModel.markCorrect()
        case .taboo:
            streak = 0
            addPop("−1", fill: Theme.taboo, on: .white)
            react(.shocked)
            viewModel.markTaboo()
        case .pass:
            streak = 0
            viewModel.markPass()
        }

        Task {
            try? await Task.sleep(for: .milliseconds(450))
            flights.removeAll { $0.id == flight.id }
        }
    }

    private func addPop(_ text: String, fill: Color, on: Color) {
        let pop = ScorePop(text: text, fill: fill, on: on)
        pops.append(pop)
        Task {
            try? await Task.sleep(for: .milliseconds(900))
            pops.removeAll { $0.id == pop.id }
        }
    }

    /// Pandanın yüzünü kısa süreliğine değiştirir.
    private func react(_ mood: PandaView.Mood) {
        reaction = mood
        reactionToken += 1
        let token = reactionToken
        Task {
            try? await Task.sleep(for: .milliseconds(900))
            if token == reactionToken {
                reaction = nil
            }
        }
    }

    // MARK: Düğmeler

    private var actionBar: some View {
        HStack(alignment: .center, spacing: 18) {
            RoundAction(swipe: .pass, size: 84, fill: tint.deep, on: tint.onDeep, badge: viewModel.passesLeft) {
                commit(.pass)
            }
            .disabled(viewModel.isPassLimitReached)
            .accessibilityLabel(viewModel.passesLeft.map { "Pas, \($0) hak kaldı" } ?? "Pas")

            RoundAction(swipe: .taboo, size: 84, fill: Theme.taboo, on: .white) {
                commit(.taboo)
            }

            RoundAction(swipe: .correct, size: 104, fill: .white, on: tint.deep) {
                commit(.correct)
            }
        }
    }

    // MARK: Duraklatma

    private var pauseOverlay: some View {
        ZStack {
            BlobBackground(base: tint.deep, blobs: [
                Blob(color: tint.pop, diameter: 120, anchor: .topTrailing, offset: CGSize(width: -10, height: 140))
            ])

            VStack(spacing: 0) {
                Spacer()
                PandaView(mood: .asleep)
                    .frame(width: 140)
                    .background {
                        Circle()
                            .fill(tint.fill)
                            .frame(width: 250, height: 250)
                    }
                Text("Mola!")
                    .font(.display(56))
                    .foregroundStyle(tint.onDeep)
                    .padding(.top, 74)
                    .accessibilityAddTraits(.isHeader)
                Text("Süre durdu, kart gizli.")
                    .font(.rounded(.body, weight: .semibold))
                    .foregroundStyle(tint.onDeep.opacity(0.8))
                Spacer()

                Button("Devam et") {
                    viewModel.resumeGame()
                }
                .buttonStyle(FilledButtonStyle(fill: .white, on: tint.deep))

                Button("Oyunu bitir") {
                    showQuitConfirm = true
                }
                .font(.rounded(.body, weight: .bold))
                .foregroundStyle(tint.onDeep)
                .frame(minHeight: 48)
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .frame(maxWidth: 520)
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
}

/// Ekrandan çıkmakta olan bir kart. Oyun durumu çoktan ilerlemiştir; bu yalnızca görüntüdür.
private struct Flight: Identifiable {
    let id = UUID()
    let card: WordCard
    let swipe: Swipe
    let start: CGSize
    let fades: Bool
}

private struct FlyingCard: View {
    let flight: Flight

    @State private var hasLeft = false

    private var end: CGSize {
        guard !flight.fades else { return flight.start }
        return CGSize(width: flight.start.width + flight.swipe.exit.width,
                      height: flight.start.height + flight.swipe.exit.height)
    }

    private var offset: CGSize { hasLeft ? end : flight.start }

    var body: some View {
        CardView(card: flight.card)
            .overlay(alignment: .top) {
                SwipeStamp(swipe: flight.swipe)
                    .offset(y: -16)
            }
            .offset(offset)
            .rotationEffect(.degrees(GameView.restTilt + Double(offset.width) / 22))
            .opacity(hasLeft && flight.fades ? 0 : 1)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .onAppear {
                withAnimation(.easeIn(duration: flight.fades ? 0.2 : 0.38)) {
                    hasLeft = true
                }
            }
    }
}

private struct SwipeStamp: View {
    let swipe: Swipe

    var body: some View {
        Label(swipe.title, systemImage: swipe.symbol)
            .font(.rounded(.headline, weight: .heavy))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(swipe.color, in: Capsule())
    }
}

/// Puan değişince skorun yanından fırlayan küçük etiket.
private struct ScorePop: Identifiable {
    let id = UUID()
    let text: String
    let fill: Color
    let on: Color
}

private struct ScorePopView: View {
    let pop: ScorePop
    let floats: Bool

    @State private var hasRisen = false

    var body: some View {
        Text(pop.text)
            .font(.display(24))
            .foregroundStyle(pop.on)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(pop.fill, in: Capsule())
            .rotationEffect(.degrees(hasRisen ? 8 : -6))
            .scaleEffect(hasRisen ? 1 : 0.4)
            .offset(y: hasRisen ? (floats ? 58 : 40) : 24)
            .opacity(hasRisen ? 1 : 0)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                    hasRisen = true
                }
            }
    }
}

/// Oyun ekranının altındaki büyük yuvarlak düğmelerden biri.
private struct RoundAction: View {
    let swipe: Swipe
    let size: CGFloat
    let fill: Color
    let on: Color
    var badge: Int?
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: swipe.symbol)
                    .font(.system(size: size * 0.3, weight: .heavy))
                Text(swipe.title)
                    .font(.rounded(.subheadline, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .foregroundStyle(on)
            .frame(width: size, height: size)
            .background(fill, in: Circle())
            .overlay(alignment: .topTrailing) {
                if let badge {
                    Text("\(badge)")
                        .font(.rounded(.subheadline, weight: .heavy))
                        .monospacedDigit()
                        .foregroundStyle(Tint.sun.on)
                        .frame(minWidth: 28, minHeight: 28)
                        .background(Tint.sun.fill, in: Circle())
                        .offset(x: 2, y: -2)
                }
            }
            .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(PressableStyle())
    }
}
