import Foundation
import SwiftUI

enum CategoryStatus {
    case active
    case comingSoon
}

struct CategoryPack: Identifiable {
    let title: String
    let icon: String
    let tint: Tint
    let desc: String
    let status: CategoryStatus
    let jsonFileName: String

    var id: String { jsonFileName }

    /// Paketteki kart sayısı; dosyadan bir kez okunur.
    var cardCount: Int { Self.cardCounts[jsonFileName] ?? 0 }

    static let allCategories: [CategoryPack] = [
        CategoryPack(title: "Klasik", icon: "star.fill", tint: .indigo,
                     desc: "Genel kültür, karışık eğlence.", status: .active, jsonFileName: "words"),

        CategoryPack(title: "Gamer", icon: "gamecontroller.fill", tint: .green,
                     desc: "Oyunlar, e-spor ve donanım kültürü.", status: .active, jsonFileName: "video_oyunlari"),

        CategoryPack(title: "Maneviyat", icon: "moon.stars.fill", tint: .teal,
                     desc: "Manevi değerler.", status: .active, jsonFileName: "ramadan_pack"),

        CategoryPack(title: "Yeşilçam", icon: "film.fill", tint: .rose,
                     desc: "Eski Türk filmleri nostaljisi.", status: .active, jsonFileName: "yesilcam"),

        CategoryPack(title: "Tarih", icon: "scroll.fill", tint: .brown,
                     desc: "Zaferler ve tarihi olaylar.", status: .active, jsonFileName: "tarih"),

        CategoryPack(title: "Sinema", icon: "popcorn.fill", tint: .coral,
                     desc: "Kült filmler ve dünya sineması.", status: .active, jsonFileName: "sinema"),

        CategoryPack(title: "İngilizce", icon: "book.fill", tint: .blue,
                     desc: "Yasaklı kelimelerle dil pratiği.", status: .active, jsonFileName: "english_pack"),

        CategoryPack(title: "Bilim Kurgu", icon: "airplane", tint: .blue,
                     desc: "Uzay, gelecek ve teknoloji.", status: .comingSoon, jsonFileName: "bilimkurgu"),

        CategoryPack(title: "Spor", icon: "figure.soccer", tint: .green,
                     desc: "Futbol, basketbol ve efsaneler.", status: .comingSoon, jsonFileName: "spor"),

        CategoryPack(title: "Müzik", icon: "music.note", tint: .rose,
                     desc: "Şarkılar ve sanatçılar.", status: .comingSoon, jsonFileName: "muzik")
    ]

    static var available: [CategoryPack] { allCategories.filter { $0.status == .active } }
    static var upcoming: [CategoryPack] { allCategories.filter { $0.status == .comingSoon } }

    private static let cardCounts: [String: Int] = {
        var counts: [String: Int] = [:]
        for pack in allCategories where pack.status == .active {
            counts[pack.jsonFileName] = DataLoader.shared.loadCards(pack.jsonFileName).count
        }
        return counts
    }()
}
