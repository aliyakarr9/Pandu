# Pandu: Yol Haritası

Son güncelleme: 19 Kasım 2026

Sıralama tarihe göre değil önceliğe göre. Her maddenin yanında neden o sırada olduğu yazıyor. Dayandığı riskler [PRD](PRD.md) belgesinde, ilgili kararlar [Kararlar](KARARLAR.md) belgesinde.

## Şimdi

Bu üç iş, ürünle ilgili en büyük belirsizliği kapatıyor: Pandu'yu şu ana kadar geliştiricisi dışında kimin, nasıl oynadığı bilinmiyor.

| İş | Neden şimdi | Bittiğini nasıl anlarız |
|---|---|---|
| TestFlight ile dağıtım | Tek kurulum yolu Xcode ile derlemek. Bu değişmeden hiçbir ölçüt ölçülemez. | Bağlantıya dokunan biri uygulamayı kurabiliyor. |
| Beş grupla gözlemli oyun testi | Hedef kullanıcı tanımı ve başarı ölçütleri hâlâ varsayım. | PRD'deki ölçüt tablosunda "Ölçülmedi" yazan satır kalmıyor. |
| Görülen kartları oyunlar arasında hatırlama | Rövanşta deste baştan karılıyor, küçük paketlerde aynı kartlar hemen geri geliyor. | Bir paketin bütün kartları görülmeden hiçbir kart ikinci kez çıkmıyor. |

## Sırada

| İş | Neden |
|---|---|
| Küçük paketleri büyütmek (önce Yeşilçam, 150 kart) | Bir oyun kabaca 60-80 kart harcıyor. 150 kart iki oyuna zor yetiyor. |
| İngilizce paketine orta ve zor kart eklemek | 348 karttan 4'ü zor. Puanlama zorluğa bağlı olduğu için paket yavaş ilerliyor. |
| "Yakında" paketleri: Bilim Kurgu, Spor, Müzik | Uygulamada söz verilmiş durumda. |
| Kart dosyaları için otomatik denetim | Tekrar eden kelime, eksik yasaklı kelime ve geçersiz zorluk değeri şu an elle aranıyor. |
| Puanlama ve tur akışı için birim testleri | Depoda test yok. Oyunun kuralları tek bir dosyada, yanlışlıkla bozulması kolay. |

## Sonra

Bu maddeler gözlemli testin sonucuna göre öne çekilebilir ya da listeden çıkabilir.

| İş | Hangi soruya bağlı |
|---|---|
| "Eşit tur" seçeneği | Oyuncular ilk başlayan takımın avantajından şikâyet ediyor mu? |
| Kuralları yeni oyunculara daha görünür kılmak | Kuralları görmemiş oyuncular ilk turda takılıyor mu, soru işaretini buluyorlar mı? |
| Üç ve dört takım | Gruplar ikiye bölünmekte zorlanıyor mu? |
| Oyuncunun kendi kartını yazması | Gruplar kendi iç şakalarını oyuna katmak istiyor mu? |
| App Store yayını | TestFlight'ta ürün yeterince olgunlaştı mı? |
| İngilizce arayüz | Türkçe bilmeyen bir kullanıcı kitlesi var mı? |

## Yapılmayacaklar

Bunlar unutulmuş değil, bilerek dışarıda bırakıldı. Gerekçeleri [Kararlar](KARARLAR.md) belgesinde.

- Çevrim içi ya da uzaktan oyun
- Hesap ve skor tablosu
- Reklam
