import Foundation
import SwiftUI

struct WordCard: Codable, Identifiable {
    let id: String
    let word: String
    let forbiddenWords: [String]
    let difficulty: String

    var pointValue: Int {
        switch difficulty {
        case "easy":   return 1
        case "medium": return 2
        case "hard":   return 3
        default:       return 1
        }
    }

    var difficultyLabel: String {
        switch difficulty {
        case "easy":   return "Kolay"
        case "medium": return "Orta"
        case "hard":   return "Zor"
        default:       return "Kolay"
        }
    }

    var difficultyColor: Color {
        switch difficulty {
        case "easy":   return .green
        case "medium": return .orange
        case "hard":   return .red
        default:       return .green
        }
    }
}
