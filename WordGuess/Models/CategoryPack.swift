import Foundation
import SwiftUI

enum CategoryStatus {
    case active
    case premium
    case event
    case comingSoon
}

struct CategoryPack: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let desc: String
    let status: CategoryStatus
    let jsonFileName: String
    
    static let allCategories: [CategoryPack] = [
        CategoryPack(title: "Ramazan", icon: "moon.stars.fill", color: .indigo,
                     desc: "İftar, sahur ve manevi değerler.", status: .event, jsonFileName: "ramadan_pack"),
        
        CategoryPack(title: "Klasik", icon: "star.fill", color: .purple,
                     desc: "Genel kültür, karışık eğlence.", status: .active, jsonFileName: "words"),
        
        CategoryPack(title: "Gamer", icon: "gamecontroller.fill", color: Color(red: 0.0, green: 0.9, blue: 0.2),
                             desc: "Oyunlar, e-spor ve donanım kültürü.", status: .premium, jsonFileName: "video_oyunlari"),
        
        CategoryPack(title: "Yeşilçam", icon: "film.fill", color: .orange,
                     desc: "Eski Türk filmleri nostaljisi.", status: .premium, jsonFileName: "yesilcam"),
        
        CategoryPack(title: "Tarih", icon: "scroll.fill", color: .brown,
                     desc: "Zaferler ve tarihi olaylar.", status: .premium, jsonFileName: "tarih"),
        
        CategoryPack(title: "Sinema", icon: "popcorn.fill", color: .red,
                     desc: "Kült filmler ve dünya sineması.", status: .active, jsonFileName: "sinema"),
        
        
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
