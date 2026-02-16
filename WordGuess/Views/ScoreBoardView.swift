import SwiftUI

struct ScoreBoardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    // Animasyon durumları
    @State private var isAnimate = false
    @State private var pulse = false

    // En yüksek skora sahip takımı belirle — güvenli erişim
    var highestScoringTeamId: UUID? {
        guard let maxScore = viewModel.teams.map(\.score).max() else { return nil }
        let topTeams = viewModel.teams.filter { $0.score == maxScore }
        // Eşit skor varsa taç yok
        return topTeams.count == 1 ? topTeams.first?.id : nil
    }
    
    var body: some View {
        ZStack {
            // MARK: - Arka Plan
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Circle()
                    .fill(viewModel.currentTeam.color.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 100)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                    .offset(y: -150)
                Spacer()
            }
            
            VStack(spacing: 0) {
                // 1. Başlık Alanı
                VStack(spacing: 5) {
                    Text("SKOR DURUMU")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(4)
                    
                    Text("Hazırlan!")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                .opacity(isAnimate ? 1 : 0)
                .offset(y: isAnimate ? 0 : -20)

                // 2. Skor Kartları (VS Modu) — güvenli erişim
                HStack(spacing: 20) {
                    ForEach(Array(viewModel.teams.enumerated()), id: \.element.id) { index, team in
                        TeamScoreCard(
                            name: team.name,
                            score: team.score,
                            color: team.color,
                            isCurrentTurn: viewModel.currentTeam.id == team.id,
                            isHighestScore: highestScoringTeamId == team.id
                        )
                        .offset(x: isAnimate ? 0 : (index == 0 ? -100 : 100))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)

                // 3. Sıradaki Takım Bilgisi
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 14))
                        Text("SIRADAKİ TAKIM")
                            .font(.system(size: 14, weight: .bold))
                            .tracking(2)
                    }
                    .foregroundColor(viewModel.currentTeam.color)
                    .opacity(0.8)
                    
                    Text(viewModel.currentTeam.name.uppercased())
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .shadow(color: viewModel.currentTeam.color.opacity(0.6), radius: 20, x: 0, y: 0)
                }
                .opacity(isAnimate ? 1 : 0)
                .scaleEffect(isAnimate ? 1 : 0.8)

                Spacer()

                // 4. Turu Başlat Butonu
                Button(action: {
                    withAnimation(.spring()) { viewModel.startRound() }
                }) {
                    HStack(spacing: 12) {
                        Text("TURU BAŞLAT")
                        Image(systemName: "play.circle.fill")
                    }
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 22)
                    .background(
                        ZStack {
                            LinearGradient(
                                colors: [viewModel.currentTeam.color, viewModel.currentTeam.color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(viewModel.currentTeam.color.opacity(0.5), lineWidth: 2)
                                .scaleEffect(pulse ? 1.05 : 1.0)
                                .opacity(pulse ? 0 : 1)
                        }
                    )
                    .cornerRadius(30)
                    .shadow(color: viewModel.currentTeam.color.opacity(0.5), radius: 20, y: 10)
                    .scaleEffect(pulse ? 1.02 : 1.0)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                .opacity(isAnimate ? 1 : 0)
                .offset(y: isAnimate ? 0 : 50)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0)) {
                isAnimate = true
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Modern ve Rekabetçi Skor Kartı
struct TeamScoreCard: View {
    let name: String
    let score: Int
    let color: Color
    let isCurrentTurn: Bool
    let isHighestScore: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(
                    LinearGradient(
                        colors: isCurrentTurn
                            ? [color.opacity(0.2), color.opacity(0.05)]
                            : [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(
                            isCurrentTurn ? color.opacity(0.6) : Color.white.opacity(0.1),
                            lineWidth: isCurrentTurn ? 2 : 1
                        )
                )
                .shadow(
                    color: isCurrentTurn ? color.opacity(0.3) : .clear,
                    radius: 20, x: 0, y: 10
                )
            
            VStack(spacing: 15) {
                if isHighestScore {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 10)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.1))
                }
                
                Text("\(score)")
                    .font(.system(size: 80, weight: .black, design: .rounded))
                    .foregroundColor(isCurrentTurn ? .white : .white.opacity(0.4))
                    .shadow(color: isCurrentTurn ? color.opacity(0.8) : .clear, radius: 15)
                    .scaleEffect(isCurrentTurn ? 1.1 : 1.0)
                
                Text(name.uppercased())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
                    .tracking(1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(color.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding(.vertical, 40)
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isCurrentTurn ? 1.05 : 0.95)
        .animation(.spring(), value: isCurrentTurn)
        .animation(.spring(), value: isHighestScore)
    }
}
