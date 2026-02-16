import SwiftUI

// MARK: - ANA UYGULAMA (APP ENTRY)
@main
struct WordGuessApp: App {
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Kalıcı siyah arka plan — geçişler sırasında beyaz pencere arkaplanının
                // görünmesini engeller
                Color.black
                    .ignoresSafeArea()
                
                switch viewModel.gameState {
                case .categorySelection:
                    CategorySelectionView(viewModel: viewModel)
                        .transition(.opacity)
                    
                case .idle:
                    HomeView(viewModel: viewModel)
                        .transition(.opacity)
                    
                case .playing, .paused:
                    GameView(viewModel: viewModel)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    
                case .betweenRounds, .roundOver:
                    ScoreBoardView(viewModel: viewModel)
                        .transition(.opacity)
                    
                case .gameOver:
                    if let winner = viewModel.teams.max(by: { $0.score < $1.score }) {
                        WinnerView(viewModel: viewModel, winner: winner)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.gameState)
        }
    }
}
