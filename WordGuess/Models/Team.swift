import Foundation

struct Team: Identifiable {
    let id: UUID = UUID()
    var name: String
    var score: Int = 0
    var tint: Tint
}
