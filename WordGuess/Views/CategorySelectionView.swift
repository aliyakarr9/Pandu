import SwiftUI

// 1. ADIM: Kategori Durum Modeli
enum CategoryStatus {
    case active      // Ücretsiz ve oynanabilir
    case premium     // Hazır ama kilitli (Ödeme bekliyor)
    case comingSoon  // Henüz yapım aşamasında
}

struct CategorySelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    
    struct CategoryItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
        let desc: String
        let status: CategoryStatus
        let jsonFileName: String
    }
    
    let categories = [
        CategoryItem(title: "Klasik", icon: "star.fill", color: .purple, desc: "Genel kültür, karışık eğlence.", status: .active, jsonFileName: "words"),
        CategoryItem(title: "Sinema", icon: "popcorn.fill", color: .red, desc: "Kült filmler ve dünya sineması.", status: .active, jsonFileName: "sinema"),
        CategoryItem(title: "Tarih", icon: "scroll.fill", color: .brown, desc: "Zaferler ve tarihi olaylar.", status: .active, jsonFileName: "tarih"),
        CategoryItem(title: "Yeşilçam", icon: "film.fill", color: .orange, desc: "Eski Türk filmleri nostaljisi.", status: .premium, jsonFileName: "yesilcam"),
        CategoryItem(title: "Bilim Kurgu", icon: "rocket.fill", color: .blue, desc: "Uzay, gelecek ve teknoloji.", status: .comingSoon, jsonFileName: "bilimkurgu"),
        CategoryItem(title: "Spor", icon: "figure.soccer", color: .green, desc: "Futbol, basketbol ve efsaneler.", status: .comingSoon, jsonFileName: "spor"),
        CategoryItem(title: "Müzik", icon: "music.note", color: .pink, desc: "Şarkılar ve sanatçılar.", status: .comingSoon, jsonFileName: "muzik")
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: -100, y: -100)
                Spacer()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PAKET SEÇ")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.purple)
                            .tracking(2)
                        
                        Text("Hangi modda\noynayacaksın?")
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(2)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 25)
                    
                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach(categories) { category in
                            Button(action: {
                                switch category.status {
                                case .active:
                                    withAnimation {
                                        viewModel.selectCategory(
                                            fileName: category.jsonFileName,
                                            categoryTitle: category.title
                                        )
                                    }
                                case .premium:
                                    print("Premium satın alma ekranı tetiklendi: \(category.title)")
                                case .comingSoon:
                                    break
                                }
                            }) {
                                PremiumCategoryCard(item: category)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .disabled(category.status == .comingSoon)
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

// 2. ADIM: PremiumCategoryCard (Yenilenmiş Tasarım)
struct PremiumCategoryCard: View {
    let item: CategorySelectionView.CategoryItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: item.status == .comingSoon
                            ? [Color.gray.opacity(0.1), Color.gray.opacity(0.05)]
                            : [item.color.opacity(0.6), item.color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            item.status == .comingSoon
                                ? Color.white.opacity(0.05)
                                : item.color.opacity(0.8),
                            lineWidth: item.status == .active ? 2 : 1
                        )
                )
            
            VStack(spacing: 0) {
                Spacer()
                
                // ORTALANMIŞ VE BÜYÜTÜLMÜŞ İKON
                ZStack {
                    Circle()
                        .fill(item.status == .active ? Color.black.opacity(0.3) : Color.white.opacity(0.05))
                        .frame(width: 65, height: 65) // Daire büyütüldü
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 30, weight: .bold)) // İkon boyutu büyütüldü
                        .foregroundColor(item.status == .comingSoon ? .gray : .white)
                }
                
                Spacer()
                
                // DAHA DİKKAT ÇEKİCİ BAŞLIK VE AÇIKLAMA
                VStack(spacing: 6) {
                    Text(item.title.uppercased())
                        .font(.system(size: 22, weight: .black, design: .rounded)) // Font büyütüldü (18 -> 22)
                        .foregroundColor(item.status == .comingSoon ? .gray : .white)
                        .multilineTextAlignment(.center)
                    
                    Text(item.desc)
                        .font(.system(size: 12, weight: .medium)) // Açıklama biraz büyütüldü
                        .foregroundColor(item.status == .comingSoon ? .gray.opacity(0.5) : .white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 25)
            }
            
            // Premium ve Yakında Overlay Katmanı
            if item.status != .active {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .opacity(0.9)
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 55, height: 55)
                        
                        Image(systemName: item.status == .premium ? "crown.fill" : "clock.fill")
                            .font(.title2)
                            .foregroundColor(item.status == .premium ? .yellow : .white.opacity(0.8))
                    }
                    
                    Text(item.status == .premium ? "PREMIUM" : "YAKINDA")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(item.status == .premium ? Color.yellow.opacity(0.9) : Color.black.opacity(0.6))
                        .cornerRadius(10)
                }
            }
        }
        .frame(height: 240) // Kart yüksekliği biraz artırıldı (220 -> 240)
        .shadow(
            color: item.status == .active ? item.color.opacity(0.4) : .clear,
            radius: item.status == .active ? 15 : 0,
            x: 0,
            y: 10
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
