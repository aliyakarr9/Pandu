import Foundation
import SwiftUI

// MARK: - Kategori Durumu
enum CategoryStatus {
    case active      // Ücretsiz ve oynanabilir
    case premium     // Hazır ama kilitli (Satın al ve Oyna)
    case event       // 🌙 SÜRELİ ETKİNLİK (Özel Tasarım + Oynanabilir)
    case comingSoon  // Henüz yapım aşamasında (Gri ve Pasif)
}

// MARK: - Kategori Paketi Modeli
struct CategoryPack: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let desc: String
    let status: CategoryStatus
    let jsonFileName: String
    
    /// Tüm kategori paketleri — tek kaynak noktası
    static let allCategories: [CategoryPack] = [
        // 🌙 RAMAZAN -> EVENT (En Üstte)
        CategoryPack(title: "Ramazan", icon: "moon.stars.fill", color: .indigo,
                     desc: "İftar, sahur ve manevi değerler.", status: .event, jsonFileName: "ramadan_pack"),
        
        CategoryPack(title: "Yeşilçam", icon: "film.fill", color: .orange,
                     desc: "Eski Türk filmleri nostaljisi.", status: .premium, jsonFileName: "yesilcam"),
        
        CategoryPack(title: "Klasik", icon: "star.fill", color: .purple,
                     desc: "Genel kültür, karışık eğlence.", status: .active, jsonFileName: "words"),
        
        CategoryPack(title: "Sinema", icon: "popcorn.fill", color: .red,
                     desc: "Kült filmler ve dünya sineması.", status: .active, jsonFileName: "sinema"),
        
        CategoryPack(title: "Tarih", icon: "scroll.fill", color: .brown,
                     desc: "Zaferler ve tarihi olaylar.", status: .active, jsonFileName: "tarih"),
        
        CategoryPack(title: "İngilizce", icon: "book.fill", color: .teal,
                     desc: "Yasaklı kelimelerle dil pratiği.", status: .active, jsonFileName: "english_pack"),
        
        CategoryPack(title: "Bilim Kurgu", icon: "airplane", color: .blue,
                     desc: "Uzay, gelecek ve teknoloji.", status: .comingSoon, jsonFileName: "bilimkurgu"),
        
        CategoryPack(title: "Spor", icon: "figure.soccer", color: .green,
                     desc: "Futbol, basketbol ve efsaneler.", status: .comingSoon, jsonFileName: "spor"),
        
        CategoryPack(title: "Müzik", icon: "music.note", color: .pink,
                     desc: "Şarkılar ve sanatçılar.", status: .comingSoon, jsonFileName: "muzik")
    ]
}
