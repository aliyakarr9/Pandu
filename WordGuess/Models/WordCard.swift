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

    var themeColor: Color {
        switch difficulty {
        case "easy":   return Color(red: 0.30, green: 0.75, blue: 0.55)
        case "medium": return Color(red: 0.90, green: 0.65, blue: 0.30)
        case "hard":   return Color(red: 0.85, green: 0.35, blue: 0.40)
        default:       return Color.purple
        }
    }
}
