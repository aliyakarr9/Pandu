import Foundation

enum GameState {
    case categorySelection // <--- YENİ: Giriş ve Paket Seçim Ekranı
    case idle              // Takım ve Süre Ayarları (HomeView)
    case playing           // Oyun Ekranı
    case paused            // Duraklatıldı
    case roundOver         // Tur Bitti
    case betweenRounds     // Skor Tablosu
    case gameOver          // Kazanan Ekranı
}
