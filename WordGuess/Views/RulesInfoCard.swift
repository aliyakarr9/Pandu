import SwiftUI

struct RulesInfoCard: View {
    let onDismiss: () -> Void
    @State private var isVisible = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(
                            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    Text("NASIL OYNANIR?")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(2)
                }
                .padding(.top, 28)
                .padding(.bottom, 20)

                VStack(spacing: 12) {
                    RuleRow(icon: "checkmark.circle.fill", iconColor: .green, title: "Doğru Bilirsen", description: "Zorluk puanı kadar puan kazanırsın")
                    RuleRow(icon: "hand.raised.fill", iconColor: .red, title: "Tabu Yaparsan", description: "−1 puan kaybedersin")
                    RuleRow(icon: "arrow.right.arrow.left", iconColor: .yellow, title: "Pas Geçersen", description: "Puan değişmez, sınırlı hakkın var")
                }
                .padding(.horizontal, 24)

                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.15), .clear], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 1)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 30)

                VStack(spacing: 6) {
                    Text("ZORLUK SEVİYELERİ")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(2)
                        .padding(.bottom, 6)
                    HStack(spacing: 14) {
                        DifficultyBadge(label: "KOLAY", points: "1", color: Color(red: 0.30, green: 0.75, blue: 0.55))
                        DifficultyBadge(label: "ORTA", points: "2", color: Color(red: 0.90, green: 0.65, blue: 0.30))
                        DifficultyBadge(label: "ZOR", points: "3", color: Color(red: 0.85, green: 0.35, blue: 0.40))
                    }
                }
                .padding(.horizontal, 24)

                Button(action: { dismiss() }) {
                    Text("ANLADIM!")
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient(colors: [.purple, .purple.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .padding(.top, 22)
                .padding(.bottom, 28)
            }
            .frame(maxWidth: 330)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 35).fill(Color.black.opacity(0.7))
                    RoundedRectangle(cornerRadius: 35).fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 35).stroke(Color.white.opacity(0.12), lineWidth: 1)
                }
            )
            .shadow(color: .purple.opacity(0.2), radius: 30, y: 15)
            .scaleEffect(isVisible ? 1.0 : 0.85)
            .opacity(isVisible ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { isVisible = true }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) { isVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { onDismiss() }
    }
}

private struct RuleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(iconColor)
                .frame(width: 36, height: 36)
                .background(iconColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white)
                Text(description).font(.system(size: 13, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.55))
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct DifficultyBadge: View {
    let label: String
    let points: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(points).font(.system(size: 28, weight: .black, design: .rounded)).foregroundColor(color)
            Text("PUAN").font(.system(size: 10, weight: .bold, design: .rounded)).foregroundColor(color.opacity(0.8)).tracking(1)
            Text(label).font(.system(size: 10, weight: .bold, design: .rounded)).foregroundColor(color.opacity(0.6)).tracking(1).padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18).fill(color.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(color.opacity(0.25), lineWidth: 1))
        )
    }
}
