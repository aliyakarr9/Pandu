# Pandu: Ürün Gereksinimleri

| | |
|---|---|
| Sürüm | 1.0 |
| Son güncelleme | 19 Kasım 2026 |
| Sahibi | Ali Yakar |
| İlgili belgeler | [Kararlar](KARARLAR.md) · [Yol haritası](YOL-HARITASI.md) |

## Problem

Tabu, kalabalık bir ortamda en kolay açılan oyunlardan biri. Ama kutu çoğu zaman o an yanınızda olmaz. Telefon ise herkesin cebindedir.

Pandu'nun çözmeye çalıştığı şey şu: bir grup "hadi tabu oynayalım" dediği andan ilk kartın ekrana gelmesine kadar araya hiçbir engel girmesin. Hesap açmak, internet aramak, paket satın almak ya da reklam izlemek o anın havasını bozar.

## Kimin için

**Asıl kullanıcı:** Bir araya gelmiş dört ve üzeri kişilik arkadaş ya da aile grubu. Ev, yurt odası, kamp, uzun yolculuk gibi yerler. İnternetin olmadığı ya da zayıf olduğu ortamlar bu tanımın içinde.

Bu grupta dikkat edilmesi gereken bir ayrıntı var: uygulama tek bir kişinin telefonunda kurulu, ama telefon elden ele dolaşıyor. Oyuncuların çoğu uygulamayı o an ilk kez görüyor. Bu yüzden her ekranın, ilk kez bakan biri için de anlaşılır olması gerekiyor.

**İkincil kullanıcı:** İngilizce pratik yapmak isteyen öğrenciler. İngilizce paketi bu grup için var.

Bu tanım henüz kullanıcı görüşmesiyle doğrulanmadı, ürünün kendisinden çıkarılmış bir varsayım. Doğrulama adımı yol haritasında.

## Temel akış

1. Uygulama açılır, paket seçilir.
2. Takım adları yazılır. Tur süresi, hedef skor ve pas hakkı istenirse değiştirilir.
3. Sıra ekranı kimin anlatacağını gösterir. Telefon o takımın anlatıcısına verilir.
4. Anlatıcı süre bitene kadar kartları anlatır. Her kart için doğru, pas ya da tabu işaretlenir.
5. Süre bitince puan takıma yazılır, sıra karşı takıma geçer.
6. Hedef skora ilk ulaşan takım kazanır. Aynı takımlarla rövanş tek dokunuşla başlar.

## 1.0'da olanlar

| Gereksinim | Ayrıntı |
|---|---|
| Paket seçimi | 7 paket, toplam 3.262 kart. Her paketin kart sayısı seçim ekranında yazar. |
| İki takım | Adları oyuncular verir. Boş bırakılırsa "1. Takım", "2. Takım" olur. |
| Ayarlar | Tur süresi 30-120 sn (varsayılan 60), hedef skor 10-100 (varsayılan 50), pas hakkı 0-10 ya da sınırsız (varsayılan 3). Cihazda saklanır. |
| Kart | Bir kelime ve beş yasaklı kelime. |
| Üç eylem | Doğru, pas, tabu. Hem kaydırarak hem düğmeyle yapılabilir. |
| Puanlama | Kolay kart 1, orta 2, zor 3 puan. Tabu 1 puan götürür. Pas puanı değiştirmez ama hakkı azaltır. |
| Sıra ekranı | Sıranın kimde olduğu, iki takımın skoru ve son turun özeti. |
| Mola | Duraklatınca kart gizlenir. Uygulama arka plana geçince oyun kendiliğinden durur. |
| Kurallar kartı | İlk oyunda kendiliğinden açılır. Sonrasında sıra ekranındaki soru işaretinden ulaşılır. |
| Erişilebilirlik | Sistem yazı boyutu, koyu mod, VoiceOver etiketleri, "Hareketi Azalt" desteği. |
| Çevrimdışı çalışma | Uygulamada ağ kodu yok. Kartlar uygulamayla birlikte gelir. |

### Paketler

| Paket | Kart | Kolay | Orta | Zor |
|---|---:|---:|---:|---:|
| Klasik | 1.441 | 754 | 533 | 154 |
| Maneviyat | 394 | 176 | 160 | 58 |
| Gamer | 393 | 137 | 150 | 106 |
| İngilizce | 348 | 262 | 82 | 4 |
| Tarih | 275 | 65 | 121 | 89 |
| Sinema | 261 | 102 | 110 | 49 |
| Yeşilçam | 150 | 37 | 78 | 35 |

## 1.0'da olmayanlar

| Konu | Neden yok |
|---|---|
| Çevrim içi ya da uzaktan oyun | Ürün aynı odadaki insanlar için. Ağ katmanı "internetsiz çalışır" sözünü de bozar. |
| Hesap, profil, skor tablosu | Oyuna girişi yavaşlatır. Telefon elden ele dolaştığı için kişisel hesabın anlamı da az. |
| Reklam ve uygulama içi satın alma | Problemin tam olarak kendisi. Bedeli [Kararlar](KARARLAR.md) belgesinde. |
| İkiden fazla takım | Oyun durumu iki takıma göre kurulu. Yol haritasında aday. |
| Oyuncunun kendi kartını yazması | İstenebilecek bir özellik, 1.0 kapsamına alınmadı. Yol haritasında aday. |
| Türkçe dışında arayüz dili | Kartların neredeyse tamamı Türkçe, önce içerik gerekir. |
| Android | Tek kişilik proje, tek platform. |

## Başarı ölçütleri

Uygulama hiçbir veri toplamıyor ve göndermiyor. Bu yüzden kullanım verisi uygulamanın içinden okunamaz. Ölçütler, oyun oynayan grupları izleyerek elle toplanacak.

| Ölçüt | Hedef | Şu anki değer |
|---|---|---|
| Uygulamayı ilk kez gören bir grubun, açılıştan ilk karta kadar geçirdiği süre | 60 saniyenin altı | Ölçülmedi |
| Telefon sahibi kuralları sözle anlatmadan ilk turu tamamlayan grupların oranı | 5 gruptan en az 4'ü | Ölçülmedi |
| Bir oturumda oynanan oyun sayısı (rövanş alışkanlığı) | Ortalama en az 2 | Ölçülmedi |
| Aynı oturumda ikinci kez görülen kart sayısı | 0 | Ölçülmedi |
| Yanlışlıkla yapılan eylem (istemeden kaydırma) | Oyun başına 1'in altı | Ölçülmedi |

Hedefler başlangıç tahmini. İlk gözlemli oyun testinden sonra gerçek değerlere göre güncellenecek.

## Riskler ve açık sorular

**Küçük paketler çabuk tükeniyor.** Yeşilçam 150 kart. Kartların ortalama değeri yaklaşık 2 puan, hedef skor 50. İki takım da hedefe yaklaştığında bir oyun kabaca 60-80 kart harcar. Rövanşta deste baştan karıldığı için ikinci oyunda aynı kartların gelmesi neredeyse kesin.

**Zorluk dağılımı paketler arasında dengesiz.** İngilizce paketinde 348 karttan yalnızca 4'ü zor. Puan zorluğa bağlı olduğu için aynı hedef skor bu pakette daha uzun sürer. Hedef skorun pakete göre ayarlanması mı, paketlerin dengelenmesi mi gerektiği açık bir soru.

**İlk başlayan takım avantajlı olabilir.** Oyun, bir takım hedefe ulaştığı anda biter. İkinci takım eşit sayıda tur oynamamış olabilir. Bunun oyuncuları rahatsız edip etmediği gözlemle anlaşılacak.

**İçerik kalitesi elle denetleniyor.** Kasım 2026'da paketlerden tekrar eden kartlar ayıklandı. Kart sayısı arttıkça tekrar ve yazım hatası riski de artıyor. Otomatik bir denetim yok.

**Ürün henüz gerçek kullanıcıya ulaşmıyor.** Şu an tek kurulum yolu kaynak kodu Xcode ile derlemek. Yukarıdaki ölçütlerin hiçbiri bu durum değişmeden anlamlı sayıda kişiyle ölçülemez.
