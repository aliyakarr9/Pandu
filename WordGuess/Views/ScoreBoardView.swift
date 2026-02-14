import SwiftUI

struct ScoreBoardView: View {
    @ObservedObject var viewModel: GameViewModel
    
    // Animasyon durumları
    @State private var isAnimate = false
    @State private var pulse = false

    // En yüksek skora sahip takımı belirle
    var highestScoringTeamId: UUID? {
        let team1 = viewModel.teams[0]
        let team2 = viewModel.teams[1]
        if team1.score > team2.score {
            return team1.id
        } else if team2.score > team1.score {
            return team2.id
        } else {
            return nil // Berabere
        }
    }
    
    var body: some View {
        ZStack {
            // MARK: - Arka Plan (Dinamik ve Nefes Alan)
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Sıradaki takımın rengine göre arka plan ışığı
            VStack {
                Circle()
                    .fill(viewModel.currentTeam.color.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 100)
                    .scaleEffect(pulse ? 1.1 : 1.0) // Nefes alma efekti
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
                .padding(.bottom, 40) // Başlık ile kartlar arası boşluk artırıldı
                .opacity(isAnimate ? 1 : 0)
                .offset(y: isAnimate ? 0 : -20)

                // 2. Skor Kartları (VS Modu)
                HStack(spacing: 20) {
                    // 1. Takım Kartı
                    TeamScoreCard(
                        name: viewModel.teams[0].name,
                        score: viewModel.teams[0].score,
                        color: viewModel.teams[0].color,
                        isCurrentTurn: viewModel.currentTeam.id == viewModel.teams[0].id,
                        isHighestScore: highestScoringTeamId == viewModel.teams[0].id // En yüksek skor kontrolü
                    )
                    .offset(x: isAnimate ? 0 : -100)
                    
                    // 2. Takım Kartı
                    TeamScoreCard(
                        name: viewModel.teams[1].name,
                        score: viewModel.teams[1].score,
                        color: viewModel.teams[1].color,
                        isCurrentTurn: viewModel.currentTeam.id == viewModel.teams[1].id,
                        isHighestScore: highestScoringTeamId == viewModel.teams[1].id // En yüksek skor kontrolü
                    )
                    .offset(x: isAnimate ? 0 : 100)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40) // Kartlar ile alt kısım arası boşluk artırıldı

                // 3. Sıradaki Takım Bilgisi (Modern HUD)
                VStack(spacing: 15) { // Başlık ve isim arası boşluk
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

                Spacer() // Kalan boşluğu doldur

                // 4. Turu Başlat Butonu (Kalp Atışı Animasyonu)
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
    let isCurrentTurn: Bool // Sıra bu takımda mı? (Glow efekti için)
    let isHighestScore: Bool // En yüksek skor bu takımda mı? (Taç için)
    
    var body: some View {
        ZStack {
            // Kart Arka Planı
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
                // Taç İkonu (En yüksek skora sahipse göster)
                if isHighestScore {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange, radius: 10)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    // Hiza bozulmasın diye boşluk
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
        // Kartın öne çıkma efekti sadece sıra ondaysa çalışır
        .scaleEffect(isCurrentTurn ? 1.05 : 0.95)
        .animation(.spring(), value: isCurrentTurn)
        // Taçın gelip gitmesi için animasyon
        .animation(.spring(), value: isHighestScore)
    }
}
