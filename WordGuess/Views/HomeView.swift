import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            // MARK: - Arka Plan
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Arka plan ışık huzmeleri
            VStack {
                HStack {
                    Circle()
                        .fill(getCategoryColor(name: viewModel.selectedCategoryName).opacity(0.25))
                        .frame(width: 300, height: 300)
                        .blur(radius: 80)
                        .offset(x: -100, y: -100)
                    Spacer()
                }
                Spacer()
            }
            
            // İçeriği Dikeyde Ortalamak için GeometryReader Kullanıyoruz
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) { // Elemanlar arası boşluk
                        
                        Spacer() // Üstten iterek ortala
                        
                        // MARK: - 1. KOMPAKT HERO KART
                        Button(action: {
                            withAnimation {
                                viewModel.returnToCategories()
                            }
                        }) {
                            CompactHeroCard(
                                categoryName: viewModel.selectedCategoryName,
                                color: getCategoryColor(name: viewModel.selectedCategoryName),
                                icon: getCategoryIcon(name: viewModel.selectedCategoryName)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.horizontal, 20)

                        // MARK: - 2. BÜTÜNLEŞİK HAZIRLIK PANELİ
                        VStack(spacing: 0) {
                            
                            // --- TAKIMLAR BÖLÜMÜ ---
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "flag.2.crossed.fill")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Karşılaşmalar")
                                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                                        .foregroundColor(.white.opacity(0.7))
                                        .tracking(2)
                                }
                                .padding(.leading, 10)
                                .padding(.top, 5)
                                
                                // GÜÇLENDİRİLMİŞ VS ALANI
                                ZStack {
                                    HStack(spacing: 15) {
                                        // 1. Takım
                                        CompetitiveTeamInput(
                                            color: .purple,
                                            placeholder: "1. Takım",
                                            text: $viewModel.teams[0].name,
                                            alignment: .leading
                                        )
                                        
                                        // 2. Takım
                                        CompetitiveTeamInput(
                                            color: .orange,
                                            placeholder: "2. Takım",
                                            text: $viewModel.teams[1].name,
                                            alignment: .trailing
                                        )
                                    }
                                    
                                    // Ortadaki VS
                                    Text("VS")
                                        .font(.system(size: 32, weight: .black, design: .rounded))
                                        .italic()
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(LinearGradient(colors: [.purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
                                        )
                                        .offset(y: -5)
                                }
                                .frame(height: 100)
                            }
                            .padding(20)
                            
                            // Ayırıcı Çizgi
                            Rectangle()
                                .fill(LinearGradient(
                                    colors: [.clear, .white.opacity(0.15), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                            
                            // --- AYARLAR BÖLÜMÜ ---
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("AYARLAR")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 10)
                                .padding(.top, 10)
                                
                                VStack(spacing: 12) {
                                    SettingsSliderRow(
                                        title: "Süre",
                                        icon: "timer",
                                        valueText: "\(viewModel.settings.roundTime)s",
                                        color: .blue,
                                        value: Binding(
                                            get: { Double(viewModel.settings.roundTime) },
                                            set: { viewModel.settings.roundTime = Int($0) }
                                        ),
                                        range: 30...120,
                                        step: 10
                                    )
                                    
                                    SettingsSliderRow(
                                        title: "Hedef",
                                        icon: "target",
                                        valueText: "\(viewModel.settings.targetScore)",
                                        color: .green,
                                        value: Binding(
                                            get: { Double(viewModel.settings.targetScore) },
                                            set: { viewModel.settings.targetScore = Int($0) }
                                        ),
                                        range: 10...100,
                                        step: 5
                                    )
                                    
                                    SettingsSliderRow(
                                        title: "Pas Hakkı",
                                        icon: "arrow.uturn.forward",
                                        valueText: viewModel.settings.maxPassCount < 0 ? "∞" : "\(viewModel.settings.maxPassCount)",
                                        color: .yellow,
                                        value: Binding(
                                            get: { Double(viewModel.settings.maxPassCount < 0 ? 11 : viewModel.settings.maxPassCount) },
                                            set: { val in
                                                if val > 10 { viewModel.settings.maxPassCount = -1 }
                                                else { viewModel.settings.maxPassCount = Int(val) }
                                            }
                                        ),
                                        range: 0...11,
                                        step: 1
                                    )
                                }
                            }
                            .padding(20)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 35)
                                .fill(.ultraThinMaterial)
                                .opacity(0.9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)

                        // MARK: - 3. BAŞLAT BUTONU
                        Button(action: {
                            withAnimation {
                                viewModel.startGame()
                            }
                        }) {
                            Text("OYUNU BAŞLAT")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    LinearGradient(
                                        colors: [getCategoryColor(name: viewModel.selectedCategoryName), getCategoryColor(name: viewModel.selectedCategoryName).opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: getCategoryColor(name: viewModel.selectedCategoryName).opacity(0.4), radius: 15, y: 8)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer() // Alttan iterek ortala
                    }
                    .frame(minHeight: geometry.size.height) // İçeriğin en az ekran boyu kadar olmasını sağlar
                }
            }
        }
    }
    
    // YARDIMCI FONKSİYONLAR
    func getCategoryColor(name: String) -> Color {
        switch name {
        case "Klasik": return .purple
        case "Sinema": return .red
        case "Tarih": return .brown
        case "Yeşilçam": return .orange
        case "Bilim Kurgu": return .blue
        case "Spor": return .green
        case "Müzik": return .pink
        default: return .purple
        }
    }
    
    func getCategoryIcon(name: String) -> String {
        switch name {
        case "Klasik": return "star.fill"
        case "Sinema": return "popcorn.fill"
        case "Tarih": return "scroll.fill"
        case "Yeşilçam": return "film.fill"
        case "Bilim Kurgu": return "rocket"
        case "Spor": return "figure.soccer"
        case "Müzik": return "music.note"
        default: return "star.fill"
        }
    }
}

// MARK: - YENİ REKABETÇİ TAKIM GİRİŞİ (AYNI KALDI)
struct CompetitiveTeamInput: View {
    let color: Color
    let placeholder: String
    @Binding var text: String
    let alignment: HorizontalAlignment
    
    var body: some View {
        ZStack(alignment: alignment == .leading ? .leading : .trailing) {
            // Arka Plan Kartı
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.25), color.opacity(0.05)],
                        startPoint: alignment == .leading ? .leading : .trailing,
                        endPoint: alignment == .leading ? .trailing : .leading
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(
                            LinearGradient(
                                colors: [color.opacity(0.7), color.opacity(0.1)],
                                startPoint: alignment == .leading ? .leading : .trailing,
                                endPoint: alignment == .leading ? .trailing : .leading
                            ),
                            lineWidth: 2
                        )
                )
            
            // İçerik
            VStack(alignment: alignment, spacing: 6) {
                Text(placeholder.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
                    .tracking(1)
                    .padding(alignment == .leading ? .leading : .trailing, 5)
                
                HStack(spacing: 5) {
                    if alignment == .trailing { Spacer(minLength: 0) }
                    
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.3)))
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
                        .submitLabel(.done)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                    
                    if alignment == .leading { Spacer(minLength: 0) }
                }
            }
            .padding(15)
        }
        .frame(maxHeight: .infinity)
    }
}

// MARK: - KOMPAKT HERO KART (AYNI KALDI)
struct CompactHeroCard: View {
    let categoryName: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("SEÇİLİ PAKET")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .tracking(1)
                Text(categoryName.uppercased())
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Değiştir")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.25))
            .clipShape(Capsule())
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [color.opacity(0.9), color.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.2), lineWidth: 1))
        )
        .shadow(color: color.opacity(0.3), radius: 15, x: 0, y: 8)
    }
}

// MARK: - SETTINGS SLIDER (AYNI KALDI)
struct SettingsSliderRow: View {
    let title: String
    let icon: String
    let valueText: String
    let color: Color
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }
            Text(title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 75, alignment: .leading)
            Slider(value: $value, in: range, step: step)
                .tint(color)
            Text(valueText)
                .font(.system(size: 16, weight: .black, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 50, alignment: .trailing)
        }
    }
}
