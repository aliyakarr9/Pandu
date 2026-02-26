import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    
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
                        ForEach(CategoryPack.allCategories) { category in
                            Button(action: {
                                switch category.status {
                                case .active, .event, .premium:
                                    withAnimation {
                                        viewModel.selectCategory(category)
                                    }
                                
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

struct PremiumCategoryCard: View {
    let item: CategoryPack
    
    var premiumGradient: LinearGradient {
        LinearGradient(colors: [.yellow, .orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var eventBackground: LinearGradient {
        LinearGradient(colors: [Color(hex: "1a0b2e"), Color(hex: "2d1b4e")], startPoint: .top, endPoint: .bottom)
    }
    
    var eventBorder: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [.orange, .purple, .yellow, .indigo, .orange]),
            center: .center
        )
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    item.status == .event
                    ? eventBackground
                    : LinearGradient(
                        colors: cardBackgroundColors(),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Group {
                        if item.status == .event {
                            StarryPattern()
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            strokeStyle(),
                            lineWidth: (item.status == .premium || item.status == .event) ? 3 : 2
                        )
                )
                .shadow(
                    color: shadowColor(),
                    radius: (item.status == .premium || item.status == .event) ? 20 : 10,
                    x: 0,
                    y: 10
                )
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if item.title == "Klasik" {
                        Text("1500+ KELİME")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow)
                            .cornerRadius(8)
                    } else if item.status == .premium {
                        ZStack {
                            Circle().fill(Color.black.opacity(0.4)).frame(width: 32, height: 32)
                            Image(systemName: "crown.fill").font(.system(size: 14)).foregroundColor(.yellow)
                        }
                    } else if item.status == .event {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.15)).frame(width: 32, height: 32)
                            Image(systemName: "sparkles").font(.system(size: 14)).foregroundColor(.yellow)
                        }
                    }
                }
                .padding(.top, 15)
                .padding(.trailing, 15)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(item.status == .active || item.status == .premium || item.status == .event ? Color.black.opacity(0.3) : Color.white.opacity(0.05))
                        .frame(width: 65, height: 65)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(item.status == .comingSoon ? .gray : .white)
                        .shadow(color: item.status == .event ? .white.opacity(0.5) : .clear, radius: 10)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text(item.title.uppercased())
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(item.status == .comingSoon ? .gray : .white)
                        .multilineTextAlignment(.center)
                        .shadow(color: (item.status == .premium || item.status == .event) ? item.color.opacity(0.8) : .clear, radius: 5)
                    
                    Text(item.desc)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(item.status == .comingSoon ? .gray.opacity(0.5) : .white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 10)
                }
                .padding(.bottom, 25)
            }
            
            if item.status == .comingSoon {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .opacity(0.9)
                VStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    Text("YAKINDA")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                }
            }
            
            if item.status == .premium {
                BadgeView(text: "GURME", background: premiumGradient, textColor: .black)
            } else if item.status == .event {
                BadgeView(
                    text: "ÖZEL ETKİNLİK",
                    background: LinearGradient(colors: [Color(hex: "ff00cc"), Color(hex: "333399")], startPoint: .leading, endPoint: .trailing),
                    textColor: .white
                )
            }
        }
        .frame(height: 240)
    }
    
    func cardBackgroundColors() -> [Color] {
        switch item.status {
        case .comingSoon: return [Color.gray.opacity(0.15), Color.gray.opacity(0.05)]
        case .premium: return [item.color.opacity(0.8), item.color.opacity(0.4)]
        case .event: return []
        case .active: return [item.color.opacity(0.8), item.color.opacity(0.4)]
        }
    }
    
    func strokeStyle() -> AnyShapeStyle {
        switch item.status {
        case .premium: return AnyShapeStyle(premiumGradient)
        case .event: return AnyShapeStyle(eventBorder)
        case .comingSoon: return AnyShapeStyle(Color.white.opacity(0.05))
        case .active: return AnyShapeStyle(item.color.opacity(0.8))
        }
    }
    
    func shadowColor() -> Color {
        switch item.status {
        case .premium: return Color.orange.opacity(0.5)
        case .event: return Color.purple.opacity(0.7)
        case .active: return item.color.opacity(0.4)
        default: return .clear
        }
    }
}

struct StarryPattern: View {
    private let stars: [(size: CGFloat, opacity: Double, x: CGFloat, y: CGFloat)]
    
    init() {
        stars = (0..<10).map { _ in
            (CGFloat.random(in: 4...10),
             Double.random(in: 0.1...0.3),
             CGFloat.random(in: 0...150),
             CGFloat.random(in: 0...200))
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(stars.indices, id: \.self) { i in
                    Image(systemName: "star.fill")
                        .font(.system(size: stars[i].size))
                        .foregroundColor(.white.opacity(stars[i].opacity))
                        .offset(x: stars[i].x, y: stars[i].y)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct BadgeView: View {
    let text: String
    let background: LinearGradient
    let textColor: Color
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(textColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(background)
                .cornerRadius(20)
                .offset(y: 10)
                .shadow(radius: 5)
        }
        .padding(.bottom, -10)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
