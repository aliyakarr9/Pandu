import Foundation
import Combine
import SwiftUI
import UIKit

// MARK: - ANA OYUN ViewModel
@MainActor
class GameViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var teams: [Team] = [
        Team(name: "1. Takım", color: .purple),
        Team(name: "2. Takım", color: .orange)
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
    
    // MARK: - Private State
    private var deck: [WordCard] = []
    private var usedCards: [WordCard] = []
    private var timerCancellable: AnyCancellable?
    private var isProcessingAction: Bool = false  // Hızlı tıklama koruması
    
    // MARK: - UserDefaults Keys
    private enum DefaultsKey {
        static let roundTime = "settings_roundTime"
        static let targetScore = "settings_targetScore"
        static let maxPassCount = "settings_maxPassCount"
    }
    
    // MARK: - Computed Properties
    
    var currentTeam: Team {
        guard teams.indices.contains(currentTeamIndex) else {
            return teams.first ?? Team(name: "Takım", color: .gray)
        }
        return teams[currentTeamIndex]
    }
    
    var isPassLimitReached: Bool {
        guard settings.maxPassCount >= 0 else { return false }
        return passesUsed >= settings.maxPassCount
    }
    
    // MARK: - Init
    
    init() {
        loadSavedSettings()
    }
    
    // MARK: - Kategori Seçimi
    
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
    
    // MARK: - Deck Yükleme (Güvenli)
    
    func loadDeck(fileName: String) {
        let file = fileName.hasSuffix(".json") ? fileName : "\(fileName).json"
        deck = DataLoader.shared.loadCards(file)
        deck.shuffle()
        usedCards.removeAll()
        isDeckEmpty = deck.isEmpty
    }
    
    // MARK: - Game Flow
    
    func startGame() {
        // Boş takım isimlerini varsayılana çevir
        for index in teams.indices {
            if teams[index].name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                teams[index].name = "\(index + 1). Takım"
            }
            teams[index].score = 0
        }
        currentTeamIndex = 0
        gameState = .betweenRounds
    }
    
    func startRound() {
        roundScore = 0
        passesUsed = 0
        isProcessingAction = false
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
    
    // MARK: - Game Logic
    
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
        guard !isProcessingAction else { return }
        isProcessingAction = true
        defer { isProcessingAction = false }
        
        roundScore += 1
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
        guard !isProcessingAction else { return }
        isProcessingAction = true
        defer { isProcessingAction = false }
        
        roundScore -= 1
        if let card = currentCard {
            usedCards.append(card)
        }
        GameFX.playTaboo()
        nextCard()
    }
    
    func markPass() {
        guard !isProcessingAction else { return }
        
        if settings.maxPassCount >= 0 && passesUsed >= settings.maxPassCount {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            return
        }
        
        isProcessingAction = true
        defer { isProcessingAction = false }
        
        passesUsed += 1
        if let card = currentCard {
            usedCards.append(card)
        }
        GameFX.playPass()
        nextCard()
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.endRound()
                }
            }
    }
    
    // MARK: - Win Check
    
    private func checkWinCondition() -> Bool {
        if teams.contains(where: { $0.score >= settings.targetScore }) {
            gameState = .gameOver
            return true
        }
        return false
    }
    
    // MARK: - UserDefaults (Ayarları Kaydet / Yükle)
    
    func saveSettings() {
        UserDefaults.standard.set(settings.roundTime, forKey: DefaultsKey.roundTime)
        UserDefaults.standard.set(settings.targetScore, forKey: DefaultsKey.targetScore)
        UserDefaults.standard.set(settings.maxPassCount, forKey: DefaultsKey.maxPassCount)
    }
    
    private func loadSavedSettings() {
        let defaults = UserDefaults.standard
        
        // Sadece daha önce kaydedilmişse yükle, yoksa default değerleri kullan
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
