import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    @State private var offset: CGSize = .zero
    @State private var showQuitAlert: Bool = false
    
    // Son 10 saniye kontrolü
    private var isTimeCritical: Bool { viewModel.timeRemaining <= 10 }
    
    private var progress: Double {
        guard viewModel.settings.roundTime > 0 else { return 0 }
        return Double(viewModel.timeRemaining) / Double(viewModel.settings.roundTime)
    }

    var body: some View {
        ZStack {
            // MARK: - Arka Plan
            LinearGradient(
                gradient: Gradient(colors: [
                    viewModel.currentTeam.color.opacity(0.4),
                    Color.black.opacity(0.9),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // MARK: - 1. Üst Panel
                HStack(spacing: 15) {
                    // Çıkış Butonu
                    Button(action: { showQuitAlert = true }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    .alert(isPresented: $showQuitAlert) {
                        Alert(
                            title: Text("Oyundan Çık?"),
                            message: Text("Mevcut oyun ilerlemesi kaybolacak."),
                            primaryButton: .destructive(Text("Çık")) { viewModel.quitGame() },
                            secondaryButton: .cancel(Text("Devam Et"))
                        )
                    }

                    // DURDURMA BUTONU
                    Button(action: {
                        withAnimation { viewModel.pauseGame() }
                    }) {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // MARK: DİNAMİK SAYAÇ
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 5)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(progress))
                            .stroke(
                                isTimeCritical ? Color.red : viewModel.currentTeam.color,
                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                            )
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear(duration: 1.0), value: progress)

                        Text("\(viewModel.timeRemaining)")
                            .font(.system(size: isTimeCritical ? 26 : 22, weight: .black, design: .monospaced))
                            .foregroundColor(isTimeCritical ? .red : .white)
                            .contentTransition(.numericText())
                            .animation(nil, value: viewModel.timeRemaining)
                            .scaleEffect(isTimeCritical ? 1.2 : 1.0)
                            .animation(isTimeCritical ? Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default, value: isTimeCritical)
                    }
                    .frame(width: 55, height: 55)

                    Spacer()

                    // Takım Bilgisi ve Skor
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(viewModel.currentTeam.name.uppercased())
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("\(viewModel.roundScore)")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: 80, alignment: .trailing)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black.opacity(0.4))
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                )
                .padding(.top, 70)
                .padding(.horizontal)

                Spacer(minLength: 20)

                // MARK: - 2. Kart Alanı
                if viewModel.isDeckEmpty {
                    // Boş deste uyarısı
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        Text("Bu kategoride kart bulunamadı.")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                } else if let card = viewModel.currentCard {
                    CardView(card: card)
                        .offset(offset)
                        .rotationEffect(Angle(degrees: Double(offset.width / 12)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if viewModel.isPassLimitReached && gesture.translation.width < 0 {
                                        offset = CGSize(width: max(gesture.translation.width, -30), height: gesture.translation.height)
                                    } else {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                        handleSwipe(width: offset.width, height: offset.height)
                                    }
                                }
                        )
                        .overlay(swipeIndicators)
                        .zIndex(1)
                } else {
                    ProgressView().tint(.white).scaleEffect(1.5)
                }

                // MARK: - 3. Pas Hakkı Bilgisi
                if viewModel.settings.maxPassCount >= 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 10))
                        Text("KALAN PAS: \(viewModel.settings.maxPassCount - viewModel.passesUsed)")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(viewModel.isPassLimitReached ? Color.red.opacity(0.4) : Color.white.opacity(0.12))
                    .foregroundColor(viewModel.isPassLimitReached ? .red : .white)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                }

                Spacer(minLength: 20)

                // MARK: - 4. Kontrol Butonları
                HStack(spacing: 30) {
                    ControlButton(icon: "arrow.right.arrow.left", label: "PAS", color: .yellow, isDisabled: viewModel.isPassLimitReached) {
                        viewModel.markPass()
                    }
                    
                    ControlButton(icon: "hand.raised.fill", label: "TABU", color: .red, isLarge: true) {
                        viewModel.markTaboo()
                    }
                    
                    ControlButton(icon: "checkmark", label: "DOĞRU", color: .green) {
                        viewModel.markCorrect()
                    }
                }
                .padding(.bottom, 60)
            }

            // MARK: - 5. Pause Overlay
            if viewModel.gameState == .paused {
                ZStack {
                    Color.black.opacity(0.85)
                        .edgesIgnoringSafeArea(.all)
                        .background(.ultraThinMaterial)

                    VStack(spacing: 30) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(viewModel.currentTeam.color)
                        
                        Text("OYUN DURAKLATILDI")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)

                        Button(action: {
                            withAnimation { viewModel.resumeGame() }
                        }) {
                            Text("DEVAM ET")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 40)
                                .background(viewModel.currentTeam.color)
                                .cornerRadius(20)
                        }
                    }
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        // MARK: - ZAMANLAYICI SES KONTROLÜ
        .onChange(of: viewModel.timeRemaining) { oldValue, newValue in
            if newValue <= 10 && newValue > 0 {
                GameFX.playTensionBeat()
            }
        }
    }

    // MARK: - Swipe Göstergeleri
    private var swipeIndicators: some View {
        ZStack {
            if offset.width > 60 { SwipeIndicatorIcon(icon: "checkmark.circle.fill", color: .green) }
            else if offset.width < -60 && !viewModel.isPassLimitReached { SwipeIndicatorIcon(icon: "arrow.right.circle.fill", color: .yellow) }
            else if offset.height > 60 { SwipeIndicatorIcon(icon: "xmark.circle.fill", color: .red) }
        }
    }

    // MARK: - Swipe İşleme
    func handleSwipe(width: CGFloat, height: CGFloat) {
        let threshold: CGFloat = 100
        if abs(width) > abs(height) {
            if width > threshold {
                viewModel.markCorrect()
            }
            else if width < -threshold && !viewModel.isPassLimitReached {
                viewModel.markPass()
            }
        } else if height > threshold {
            viewModel.markTaboo()
        }
        offset = .zero
    }
}
