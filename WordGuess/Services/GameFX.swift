import AudioToolbox
import UIKit

@MainActor
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
    
    static func playTimeUp() {
        AudioServicesPlaySystemSound(1005)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
