import Foundation
import Combine
import SwiftUI
import UIKit

struct RoundSummary: Equatable {
    let teamName: String
    let score: Int
}

@MainActor
class GameViewModel: ObservableObject {
    
    @Published var teams: [Team] = [
        Team(name: "1. Takım", tint: .indigo),
        Team(name: "2. Takım", tint: .amber)
    ]
    @Published var currentTeamIndex: Int = 0
    @Published var gameState: GameState = .categorySelection
    @Published var currentCard: WordCard?
    @Published var timeRemaining: Int = 60
    @Published var roundScore: Int = 0
    @Published var passesUsed: Int = 0
    @Published var settings: GameSettings = GameSettings()
    @Published var selectedCategory: CategoryPack?
    @Published var isDeckEmpty: Bool = false
    @Published var showRulesCard: Bool = false
    @Published var lastRound: RoundSummary?
    
    private var deck: [WordCard] = []
    private var usedCards: [WordCard] = []
    private var timerCancellable: AnyCancellable?
    
    private enum DefaultsKey {
        static let roundTime = "settings_roundTime"
        static let targetScore = "settings_targetScore"
        static let maxPassCount = "settings_maxPassCount"
        static let hasSeenRules = "hasSeenRules"
    }
    
    var currentTeam: Team {
        guard teams.indices.contains(currentTeamIndex) else {
            return teams.first ?? Team(name: "Takım", tint: .indigo)
        }
        return teams[currentTeamIndex]
    }
    
    /// Kalan pas hakkı; sınırsızsa nil.
    var passesLeft: Int? {
        guard settings.maxPassCount >= 0 else { return nil }
        return max(0, settings.maxPassCount - passesUsed)
    }

    var isPassLimitReached: Bool {
        guard settings.maxPassCount >= 0 else { return false }
        return passesUsed >= settings.maxPassCount
    }
    
    init() {
        loadSavedSettings()
    }
    
    func selectCategory(_ category: CategoryPack) {
        self.selectedCategory = category
        loadDeck(fileName: category.jsonFileName)
        withAnimation {
            gameState = .idle
        }
    }
    
    func returnToCategories() {
        timerCancellable?.cancel()
        withAnimation {
            gameState = .categorySelection
        }
    }
    
    func loadDeck(fileName: String) {
        let file = fileName.hasSuffix(".json") ? fileName : "\(fileName).json"
        deck = DataLoader.shared.loadCards(file)
        deck.shuffle()
        usedCards.removeAll()
        isDeckEmpty = deck.isEmpty
    }
    
    func startGame() {
        for index in teams.indices {
            if teams[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                teams[index].name = "\(index + 1). Takım"
            }
            teams[index].score = 0
        }
        currentTeamIndex = 0
        lastRound = nil
        showRulesCard = !UserDefaults.standard.bool(forKey: DefaultsKey.hasSeenRules)
        gameState = .betweenRounds
    }

    /// Aynı takımlar ve paketle yeni bir oyun başlatır.
    func rematch() {
        timerCancellable?.cancel()
        if let category = selectedCategory {
            loadDeck(fileName: category.jsonFileName)
        }
        startGame()
    }

    func markRulesSeen() {
        UserDefaults.standard.set(true, forKey: DefaultsKey.hasSeenRules)
    }
    
    func startRound() {
        roundScore = 0
        passesUsed = 0
        timeRemaining = settings.roundTime
        gameState = .playing
        nextCard()
        startTimer()
    }
    
    func pauseGame() {
        gameState = .paused
        timerCancellable?.cancel()
    }
    
    func resumeGame() {
        gameState = .playing
        startTimer()
    }
    
    func endRound() {
        timerCancellable?.cancel()
        
        guard teams.indices.contains(currentTeamIndex) else { return }
        teams[currentTeamIndex].score += roundScore
        lastRound = RoundSummary(teamName: teams[currentTeamIndex].name, score: roundScore)
        
        if checkWinCondition() { return }
        
        gameState = .betweenRounds
        GameFX.playTimeUp()
        
        currentTeamIndex = (currentTeamIndex + 1) % teams.count
    }
    
    func quitGame() {
        timerCancellable?.cancel()
        resetGame()
    }
    
    func resetGame() {
        gameState = .idle
        for index in teams.indices {
            teams[index].score = 0
        }
        currentTeamIndex = 0
        if let category = selectedCategory {
            loadDeck(fileName: category.jsonFileName)
        }
    }
    
    func nextCard() {
        if deck.isEmpty {
            if usedCards.isEmpty {
                isDeckEmpty = true
                return
            }
            deck = usedCards
            usedCards.removeAll()
            deck.shuffle()
        }
        isDeckEmpty = false
        guard !deck.isEmpty else { return }
        currentCard = deck.removeFirst()
    }
    
    func markCorrect() {
        roundScore += currentCard?.pointValue ?? 1
        if let card = currentCard {
            usedCards.append(card)
        }
        GameFX.playCorrect()
        
        guard teams.indices.contains(currentTeamIndex) else { return }
        let currentTotalScore = teams[currentTeamIndex].score + roundScore
        if currentTotalScore >= settings.targetScore {
            teams[currentTeamIndex].score = currentTotalScore
            timerCancellable?.cancel()
            gameState = .gameOver
            return
        }
        nextCard()
    }
    
    func markTaboo() {
        roundScore -= 1
        if let card = currentCard {
            usedCards.append(card)
        }
        GameFX.playTaboo()
        nextCard()
    }
    
    func markPass() {
        if settings.maxPassCount >= 0 && passesUsed >= settings.maxPassCount {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            return
        }

        passesUsed += 1
        if let card = currentCard {
            usedCards.append(card)
        }
        GameFX.playPass()
        nextCard()
    }
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
                if self.timeRemaining == 0 {
                    self.endRound()
                }
            }
    }
    
    private func checkWinCondition() -> Bool {
        if teams.contains(where: { $0.score >= settings.targetScore }) {
            gameState = .gameOver
            return true
        }
        return false
    }
    
    func saveSettings() {
        UserDefaults.standard.set(settings.roundTime, forKey: DefaultsKey.roundTime)
        UserDefaults.standard.set(settings.targetScore, forKey: DefaultsKey.targetScore)
        UserDefaults.standard.set(settings.maxPassCount, forKey: DefaultsKey.maxPassCount)
    }
    
    private func loadSavedSettings() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: DefaultsKey.roundTime) != nil {
            settings.roundTime = defaults.integer(forKey: DefaultsKey.roundTime)
        }
        if defaults.object(forKey: DefaultsKey.targetScore) != nil {
            settings.targetScore = defaults.integer(forKey: DefaultsKey.targetScore)
        }
        if defaults.object(forKey: DefaultsKey.maxPassCount) != nil {
            settings.maxPassCount = defaults.integer(forKey: DefaultsKey.maxPassCount)
        }
    }
}
