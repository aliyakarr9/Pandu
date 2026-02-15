import SwiftUI

// MARK: - YENİ PREMİUM ŞAMPİYON EKRANI (WinnerView)
struct WinnerView: View {
    @ObservedObject var viewModel: GameViewModel
    let winner: Team
    
    // Animasyon durumları
    @State private var showTrophy = false
    @State private var showText = false
    @State private var showScore = false
    @State private var showButton = false
    @State private var pulseBackground = false

    var body: some View {
        ZStack {
            // MARK: KATMAN 1 - Arka Plan
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Neon Işık (Nefes Alan Efekt)
            RadialGradient(colors: [winner.color.opacity(0.5), .clear], center: .center, startRadius: 10, endRadius: 400)
                .scaleEffect(pulseBackground ? 1.2 : 0.9)
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseBackground)
            
            // MARK: KATMAN 2 - İçerik
            VStack(spacing: 25) {
                
                Spacer()
                
                // Kupa ve Taç
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.2))
                        .frame(width: 250, height: 250)
                        .blur(radius: 50)
                    
                    VStack(spacing: -15) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 10)
                            .offset(y: showTrophy ? 0 : -50)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 130))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom),
                                .yellow
                            )
                            .shadow(color: .orange.opacity(0.5), radius: 20)
                    }
                }
                .scaleEffect(showTrophy ? 1.0 : 0.1)
                .rotationEffect(.degrees(showTrophy ? 0 : -15))
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showTrophy)

                // Şampiyon Metni
                VStack(spacing: 10) {
                    Text("ŞAMPİYON")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .tracking(10)
                    
                    Text(winner.name.uppercased())
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: winner.color, radius: 15)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 10)
                        .scaleEffect(showText ? 1.0 : 0.5)
                        .opacity(showText ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showText)
                }

                // Skor Kartı
                VStack(spacing: 5) {
                    Text("TOPLAM SKOR")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(winner.color.opacity(0.9))
                        .tracking(3)
                    
                    Text("\(winner.score)")
                        .font(.system(size: 110, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 45)
                            .fill(Color.white.opacity(0.06))
                        
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(
                                LinearGradient(colors: [winner.color, .clear, winner.color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 3
                            )
                    }
                )
                .padding(.horizontal, 20)
                .scaleEffect(showScore ? 1.0 : 0.8)
                .opacity(showScore ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showScore)

                Spacer()

                // Ana Menü Butonu
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    withAnimation { viewModel.quitGame() }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: "house.fill")
                        Text("ANA MENÜYE DÖN")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 22)
                    .background(
                        LinearGradient(colors: [winner.color, winner.color.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(color: winner.color.opacity(0.5), radius: 20, y: 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .offset(y: showButton ? 0 : 100)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showButton)
            }
        }
        .onAppear {
            pulseBackground = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { showTrophy = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showText = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { showScore = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showButton = true }
        }
    }
}

// MARK: - ANA UYGULAMA (APP ENTRY)
@main
struct WordGuessApp: App {
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch viewModel.gameState {
                case .categorySelection:
                    CategorySelectionView(viewModel: viewModel)
                        .transition(.opacity)
                    
                case .idle:
                    HomeView(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                    
                case .playing, .paused:
                    GameView(viewModel: viewModel)
                        .transition(.move(edge: .bottom))
                    
                case .betweenRounds, .roundOver:
                    ScoreBoardView(viewModel: viewModel)
                        .transition(.opacity.combined(with: .scale))
                    
                case .gameOver:
                    if let winner = viewModel.teams.max(by: { $0.score < $1.score }) {
                        WinnerView(viewModel: viewModel, winner: winner)
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        WinnerView(viewModel: viewModel, winner: viewModel.teams[0])
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.gameState)
        }
    }
}
