import SwiftUI

@main
struct WordGuessApp: App {
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                backdrop
                    .ignoresSafeArea()

                switch viewModel.gameState {
                case .categorySelection:
                    CategorySelectionView(viewModel: viewModel)
                        .transition(.move(edge: .leading))
                        .zIndex(1)

                case .idle:
                    HomeView(viewModel: viewModel)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)

                case .playing, .paused:
                    GameView(viewModel: viewModel)
                        .transition(.opacity)
                        .zIndex(1)

                case .betweenRounds, .roundOver:
                    ScoreBoardView(viewModel: viewModel)
                        .transition(.opacity)
                        .zIndex(1)

                case .gameOver:
                    if let winner = viewModel.teams.max(by: { $0.score < $1.score }) {
                        WinnerView(viewModel: viewModel, winner: winner, teams: viewModel.teams)
                            .transition(.opacity)
                            .zIndex(1)
                    }
                }
            }
            .animation(.snappy(duration: 0.35), value: viewModel.gameState)
        }
    }

    /// Ekranlar arası geçişte arkada görünen zemin; oyun sırasında takımın rengidir.
    private var backdrop: Color {
        switch viewModel.gameState {
        case .playing, .paused, .betweenRounds, .roundOver:
            return viewModel.currentTeam.tint.fill
        case .categorySelection:
            return Tint.sun.fill
        case .idle:
            return viewModel.selectedCategory?.tint.fill ?? Tint.sun.fill
        case .gameOver:
            return viewModel.teams.max(by: { $0.score < $1.score })?.tint.fill ?? Theme.background
        }
    }
}
