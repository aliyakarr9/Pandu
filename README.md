# 🚀 Pandu - Kelime Tahmin Oyunu - iOS

![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-red)
![License](https://img.shields.io/badge/License-MIT-green)

**Pandu, arkadaş ortamlarının ve toplanmaların vazgeçilmezi olan klasik kelime tahmin (tabu) oyununu modern, dinamik ve neon bir tasarımla mobil cihazlara taşıyan yeni nesil bir iOS uygulamasıdır. Standart ve sıkıcı tahmin oyunlarının aksine, **Pandu** tamamen kullanıcı deneyimine (UX) odaklanır; akıcı animasyonları, göz yormayan karanlık modu ve tamamı ücretsiz, devasa kelime haznesiyle öne çıkar.

---

## ✨ Öne Çıkan Özellikler

* 📚 **Geniş ve Güncel Kütüphane:** Yenilikçi ve özenle seçilmiş **2500'den fazla** kelime. Sürekli güncellenen veritabanı.
* 🎭 **Tematik Modlar ve Paketler:** Her moda özel renk paletleri ve hissiyat!
  * **Klasik:** Genel kültür ve karışık kelimeler.
  * **Yeşilçam & Sinema:** Nostaljik Türk filmleri ve dünya sineması klasikleri.
  * **Gamer:** E-spor, oyun kültürü ve donanım terimleri.
  * **Tarih:** Tarihi olaylar, liderler ve zaferler.
  * **İngilizce:** Dil pratiği yapmak isteyenler için özel İngilizce kelime paketi.
* ⚔️ **Gelişmiş Versus Modu:** Uygulama içi akıllı takım yönetimi. Takım isimlerini özelleştirin ve kıyasıya bir rekabete başlayın. Puan durumu eşzamanlı ve şık bir skor tablosunda takip edilir.
* 🎨 **Premium Neon UI:** Göz yormayan, yüksek kontrastlı ve tamamen SwiftUI ile geliştirilmiş, akıcılığa odaklanan "Dark Mode" arayüz.
* 🎉 **Tatmin Edici Animasyonlar ve Sesler (Haptics):** 
  * Şampiyonluk ekranında kalp atışı (pulse) efektleri ve kupa animasyonları.
  * Doğru/Yanlış ve Pas durumlarında anlık titreşim (Haptic Feedback) ve özel ses efektleri.
  * Kartları kaydırarak (Swipe) kolay oyun kontrolü.
* ⚙️ **Esnek Oyun Dinamikleri:** Tur süresi (30sn-120sn), hedef skor (10-100) ve pas hakkı (sınırsız veya kısıtlı) gibi dinamikleri tamamen grubunuza göre kişiselleştirin.

---

## 📸 Ekran Görüntüleri

| Paket Seçimi | Oyun Ayarları | Oyun Ekranı |
|---|---|---|
| <img src="Screenshots/paketekrani.jpeg" width="220"> | <img src="Screenshots/ayarekrani.jpeg" width="220"> | <img src="Screenshots/oyunekrani.jpeg" width="220"> |

| Skor Tablosu | Şampiyon Ekranı |
|---|---|
| <img src="Screenshots/skorekrani.jpeg" width="220"> | <img src="Screenshots/sampiyonekrani.jpeg" width="220"> |

---

## 🛠 Teknik Detaylar & Mimari

Projeyi geliştirirken Apple'ın modern teknolojileri ve en iyi mimari yaklaşımlar (Best Practices) kullanılmıştır:

* **Mimari:** Kesin hatlarla ayrılmış **MVVM (Model-View-ViewModel)** mimarisi.
* **Kullanıcı Arayüzü:** `%100 SwiftUI` ile Declarative (Bildirimsel) UI tasarımı. Zengin görsel katmanlar (ZStack) ve özel gradient teknikleri.
* **State Management:** Veri akışı ve senkronizasyon için iOS'un gücü olan `@StateObject`, `@ObservedObject` ve `@Binding` yapıları.
* **Animasyonlar:** SwiftUI Transitions, MatchGeometryEffect ve ince ayarlanmış Spring (Yay) animasyonları.
* **Geri Bildirim:** Cihaz titreşim motoru için `UIFeedbackGenerator` entegrasyonu.
* **Veri Yükleme:** JSON tabanlı lokal veritabanı yönetimi ile sıfır gecikme (Zero-latency offline veri ayrıştırma).

---

## 🚀 Kurulum & Çalıştırma

Projeyi kendi ortamınızda incelemek veya geliştirmek için aşağıdaki adımları izleyebilirsiniz:

1.  Bu depoyu bilgisayarınıza klonlayın:
    ```bash
    git clone https://github.com/aliyakarr9/WordGuess.git
    ```
2.  İndirdiğiniz klasördeki `WordGuess.xcodeproj` dosyasını çift tıklayarak **Xcode** üzerinde açın.
3.  Üst menüden uygun bir **Simülatör** veya bilgisayarınıza bağlı gerçek bir **iOS cihazı** seçin.
4.  `Cmd + R` tuş kombinasyonuna basarak (veya Play butonuna tıklayarak) projeyi derleyip çalıştırın.

---

## 🤝 Katkıda Bulunma

Eğer kelime kütüphanesine yeni kelimeler eklemek, yeni kategoriler oluşturmak veya mevcut bir hatayı düzeltmek isterseniz:
1. Projeyi *fork* edin.
2. Yeni bir dal (branch) oluşturun (`git checkout -b feature/yeni-ozellik`).
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`).
4. Dalınıza (branch) push yapın (`git push origin feature/yeni-ozellik`).
5. Bir Pull Request (PR) oluşturun.

---

👨‍💻 **Geliştiren & Tasarlayan:** [Ali Yakar](https://github.com/aliyakarr9)  
