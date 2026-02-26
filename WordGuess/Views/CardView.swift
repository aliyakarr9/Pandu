import SwiftUI

struct CardView: View {
    let card: WordCard

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: difficultyIcon)
                    .font(.system(size: 11, weight: .black))
                Text(difficultyLabel)
                    .font(.system(size: 11, weight: .black, design: .rounded))
                Text("· \(card.pointValue) PUAN")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .foregroundColor(card.themeColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(card.themeColor.opacity(0.15))
                    .overlay(
                        Capsule()
                            .stroke(card.themeColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.top, 18)

            VStack(spacing: 12) {
                Text("ANA KELİME")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(4)
                
                Text(card.word.uppercased())
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 1, y: 1)
                    .shadow(color: card.themeColor.opacity(0.5), radius: 15)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 35)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black.opacity(0.25))
                    .padding(10)
            )

            ZStack {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)
                Capsule()
                    .fill(LinearGradient(colors: [.clear, card.themeColor.opacity(0.7), .clear], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 220, height: 4)
                    .blur(radius: 1)
            }
            .padding(.vertical, 10)

            VStack(spacing: 20) {
                Text("YASAKLI KELİMELER")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red.opacity(0.9))
                    .tracking(3)
                
                VStack(spacing: 14) {
                    ForEach(Array(card.forbiddenWords.enumerated()), id: \.offset) { _, word in
                        Text(word.uppercased())
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.8), radius: 2)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .frame(width: 340, height: 540)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.black.opacity(0.55))
                
                RoundedRectangle(cornerRadius: 40)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 40)
                    .stroke(
                        LinearGradient(
                            colors: [card.themeColor.opacity(0.5), .clear, card.themeColor.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .shadow(color: Color.black.opacity(0.5), radius: 30, x: 0, y: 20)
        .shadow(color: card.themeColor.opacity(0.15), radius: 20, x: 0, y: 10)
    }

    private var difficultyLabel: String {
        switch card.difficulty {
        case "easy":   return "KOLAY"
        case "medium": return "ORTA"
        case "hard":   return "ZOR"
        default:       return "?"
        }
    }

    private var difficultyIcon: String {
        switch card.difficulty {
        case "easy":   return "star"
        case "medium": return "star.leadinghalf.filled"
        case "hard":   return "star.fill"
        default:       return "star"
        }
    }
}
