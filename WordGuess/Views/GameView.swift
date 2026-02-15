import SwiftUI
import AudioToolbox // Ses efektleri için gerekli

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

    @State private var offset: CGSize = .zero
    @State private var showQuitAlert: Bool = false
    
    // Son 10 saniye kontrolü
    private var isTimeCritical: Bool { viewModel.timeRemaining <= 10 }
    
    private var progress: Double {
        Double(viewModel.timeRemaining) / Double(viewModel.settings.roundTime)
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

                    // MARK: DİNAMİK SAYAÇ (Düzeltilen Kısım)
                    ZStack {
                        // Arka halka
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 5)
                        
                        // İlerleme halkası
                        Circle()
                            .trim(from: 0.0, to: CGFloat(progress))
                            .stroke(
                                isTimeCritical ? Color.red : viewModel.currentTeam.color,
                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                            )
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear(duration: 1.0), value: progress) // Sadece halkayı yumuşat

                        // Sayaç Metni
                        Text("\(viewModel.timeRemaining)")
                            .font(.system(size: isTimeCritical ? 26 : 22, weight: .black, design: .monospaced))
                            .foregroundColor(isTimeCritical ? .red : .white)
                            // HATA ÇÖZÜMÜ: Sayı değişimini animasyondan koru (iOS 16+ için numericText, öncesi için id değişikliği)
                            .contentTransition(.numericText())
                            .animation(nil, value: viewModel.timeRemaining) // Sayı değişirken animasyon yapma!
                            
                            // Kalp atışı efekti (Sadece boyutu etkiler)
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
                if let card = viewModel.currentCard {
                    InternalModernCardView(card: card)
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
                    // PAS
                    InternalControlButton(icon: "arrow.right.arrow.left", label: "PAS", color: .yellow, isDisabled: viewModel.isPassLimitReached) {
                        GameFX.playPass()
                        viewModel.markPass()
                    }
                    
                    // TABU
                    InternalControlButton(icon: "hand.raised.fill", label: "TABU", color: .red, isLarge: true) {
                        GameFX.playTaboo()
                        viewModel.markTaboo()
                    }
                    
                    // DOĞRU
                    InternalControlButton(icon: "checkmark", label: "DOĞRU", color: .green) {
                        GameFX.playCorrect()
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
            // Son 10 saniye kala, her saniye "Tik" sesi ve titreşim
            if newValue <= 10 && newValue > 0 {
                GameFX.playTensionBeat()
            }
        }
    }

    private var swipeIndicators: some View {
        ZStack {
            if offset.width > 60 { InternalSwipeIndicatorIcon(icon: "checkmark.circle.fill", color: .green) }
            else if offset.width < -60 && !viewModel.isPassLimitReached { InternalSwipeIndicatorIcon(icon: "arrow.right.circle.fill", color: .yellow) }
            else if offset.height > 60 { InternalSwipeIndicatorIcon(icon: "xmark.circle.fill", color: .red) }
        }
    }

    func handleSwipe(width: CGFloat, height: CGFloat) {
        let threshold: CGFloat = 100
        if abs(width) > abs(height) {
            if width > threshold {
                GameFX.playCorrect()
                viewModel.markCorrect()
            }
            else if width < -threshold && !viewModel.isPassLimitReached {
                GameFX.playPass()
                viewModel.markPass()
            }
        } else if height > threshold {
            GameFX.playTaboo()
            viewModel.markTaboo()
        }
        offset = .zero
    }
}

// MARK: - SES VE TİTREŞİM YÖNETİCİSİ (GameFX)
struct GameFX {
    static func playCorrect() {
        AudioServicesPlaySystemSound(1001)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func playTaboo() {
        AudioServicesPlaySystemSound(1053)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    static func playPass() {
        AudioServicesPlaySystemSound(1104)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    static func playTensionBeat() {
        AudioServicesPlaySystemSound(1103)
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}

// MARK: - ÖZEL ALT BİLEŞENLER

struct InternalModernCardView: View {
    let card: WordCard

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("ANA KELİME")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(4)
               
                Text(card.word.uppercased())
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 25)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black.opacity(0.4))
                    .padding(10)
            )

            ZStack {
                Capsule().fill(Color.white.opacity(0.1)).frame(height: 1)
                Capsule().fill(LinearGradient(colors: [.clear, .purple.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)).frame(width: 240, height: 4)
            }
            .padding(.vertical, 10)

            VStack(spacing: 18) {
                Text("YASAKLI KELİMELER")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red.opacity(0.9))
                    .tracking(3)
               
                VStack(spacing: 12) {
                    ForEach(card.forbiddenWords, id: \.self) { word in
                        Text(word.uppercased())
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                            .shadow(color: .black, radius: 2)
                    }
                }
            }
            .padding(.vertical, 25)
        }
        .frame(width: 340, height: 530)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.black.opacity(0.65))
                    .background(.ultraThinMaterial)
                    .cornerRadius(40)
               
                RoundedRectangle(cornerRadius: 40)
                    .stroke(LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
            }
        )
        .shadow(color: Color.black.opacity(0.5), radius: 30, x: 0, y: 20)
    }
}

struct InternalControlButton: View {
    let icon: String
    let label: String
    let color: Color
    var isDisabled: Bool = false
    var isLarge: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: isLarge ? 32 : 24, weight: .bold))
                Text(label)
                    .font(.system(size: 12, weight: .black))
            }
            .frame(width: isLarge ? 90 : 75, height: isLarge ? 90 : 75)
            .background(
                ZStack {
                    if isDisabled {
                        Circle().fill(Color.white.opacity(0.1))
                    } else {
                        Circle().fill(color.opacity(0.15))
                        Circle().stroke(color.opacity(0.4), lineWidth: 2)
                    }
                }
            )
            .foregroundColor(isDisabled ? .white.opacity(0.2) : color)
        }
        .disabled(isDisabled)
    }
}

struct InternalSwipeIndicatorIcon: View {
    let icon: String
    let color: Color
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 80))
            .foregroundColor(color)
            .shadow(color: color.opacity(0.5), radius: 20)
            .opacity(0.8)
    }
}
