import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            // MARK: - Arka Plan
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: - 1. Başlık Bölümü
                    VStack(spacing: 12) {
                        Text("Kelime Tahmini")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Arkadaşlarınla eğlenceye hazır mısın?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 80)

                    // MARK: - 2. Takımlar Kartı
                    VStack(alignment: .leading, spacing: 15) {
                        Label("Takımlar", systemImage: "person.2.fill")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing: 12) {
                            ModernTeamInput(
                                color: .purple,
                                placeholder: "1. Takım",
                                text: $viewModel.teams[0].name
                            )
                            
                            Text("VS")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundColor(.white.opacity(0.2))
                                .padding(.top, 10)
                            
                            ModernTeamInput(
                                color: .orange,
                                placeholder: "2. Takım",
                                text: $viewModel.teams[1].name
                            )
                        }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(30)
                    .padding(.horizontal, 20)

                    // MARK: - 3. Ayarlar Kartı (GÜNCELLENDİ)
                    VStack(alignment: .leading, spacing: 20) {
                        Label("Oyun Ayarları", systemImage: "gearshape.fill")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        VStack(spacing: 15) { // Boşluklar biraz daraltıldı
                            
                            // Paket Seçimi Satırı
                            Button(action: {
                                withAnimation {
                                    viewModel.returnToCategories()
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AKTİF PAKET")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white.opacity(0.4))
                                        
                                        Text(viewModel.selectedCategoryName)
                                            .font(.system(size: 18, weight: .black, design: .rounded))
                                            .foregroundColor(.purple)
                                    }
                                    Spacer()
                                    HStack(spacing: 8) {
                                        Text("Değiştir")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white.opacity(0.4))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                                )
                            }

                            Divider().background(Color.white.opacity(0.1))

                            // YENİ MODERN SLIDERLAR
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
                                title: "Pas",
                                icon: "forward.fill",
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
                    .padding(25)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(30)
                    .padding(.horizontal, 20)

                    // MARK: - 4. Başla Butonu
                    Button(action: {
                        withAnimation {
                            viewModel.startGame()
                        }
                    }) {
                        Text("OYUNU BAŞLAT")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .purple.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - Alt Bileşenler (Modern Team Input)
struct ModernTeamInput: View {
    let color: Color
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Capsule()
                .fill(color)
                .frame(width: 30, height: 4)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.2)))
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.08))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - YENİ MODERN VE KÜÇÜK SLIDER BİLEŞENİ
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
            // İkon ve Başlık Grubu
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: 70, alignment: .leading)
            
            // Slider
            Slider(value: $value, in: range, step: step)
                .tint(color)
                .scaleEffect(0.9) // Slider'ı biraz küçülttük
            
            // Değer Göstergesi
            Text(valueText)
                .font(.system(size: 14, weight: .black, design: .monospaced))
                .foregroundColor(color)
                .frame(width: 45, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}
