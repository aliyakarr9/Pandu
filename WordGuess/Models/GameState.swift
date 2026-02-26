import Foundation

enum GameState: Equatable {
    case categorySelection
    case idle
    case playing
    case paused
    case roundOver
    case betweenRounds
    case gameOver
}
