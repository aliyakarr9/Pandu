# Pandu: Ürün Kararları

Bu belge, Pandu'da alınan kararları ve her birinin bedelini kaydeder. Amaç, "bu neden böyle?" sorusunun cevabını kodda değil burada bulmak.

Her karar üç parçadan oluşur: ne seçildi, neden seçildi, karşılığında neden vazgeçildi.

İlgili belgeler: [PRD](PRD.md) · [Yol haritası](YOL-HARITASI.md)

---

## 1. Tek cihaz, internetsiz

**Karar:** Oyun tek telefonda oynanır. Uygulamada ağ kodu yoktur.

**Neden:** Oyuncular zaten aynı odada. Telefonu elden ele vermek oyunun parçası. İnternet gerektirmemek, uygulamayı kampta ya da yolda da kullanılır kılıyor.

**Bedeli:** Kart içeriği uzaktan güncellenemez, her yeni paket uygulama güncellemesi ister. Kullanım verisi de toplanamaz, bu yüzden başarı ölçütleri elle gözlemle ölçülmek zorunda.

## 2. Bütün paketler ücretsiz, reklam yok

**Karar:** Kilitli paket, uygulama içi satın alma ve reklam yok.

**Neden:** Ürünün varlık sebebi, oyuna başlamanın önündeki engelleri kaldırmak. Tur arasında çıkan bir reklam ya da kilitli bir paket bu sözle çelişir.

**Bedeli:** Ürün gelir üretmiyor. İçerik üretimi büyüdükçe bunun sürdürülebilirliği yeniden değerlendirilmeli.

## 3. Kartlar JSON dosyalarında

**Karar:** Her paket `Resources/` altında ayrı bir JSON dosyası. Kart yapısı sabit: kelime, beş yasaklı kelime, zorluk.

**Neden:** Yeni kart eklemek için Swift bilmek gerekmiyor. Paket eklemek kod değişikliği olmaktan çıkıp içerik işine dönüşüyor. Dışarıdan katkı da kolaylaşıyor.

**Bedeli:** Dosyalar elle düzenlendiği için tekrar ve yazım hatası girebiliyor. Kasım 2026'da altı pakette tekrar eden kartlar elle ayıklandı.

## 4. Puan kartın zorluğuna bağlı

**Karar:** Kolay kart 1, orta 2, zor 3 puan. Tabu 1 puan götürür.

**Neden:** Zor kartı anlatmanın karşılığı olmazsa anlatıcı onu hemen pas geçer. Farklı puan, zor kartı denemeye değer kılıyor.

**Bedeli:** Paketlerin zorluk dağılımı oyunun süresini etkiliyor. Zor kartı az olan pakette aynı hedef skora ulaşmak daha uzun sürüyor. Paket dengesi artık bir ürün sorunu.

## 5. Pas ücretsiz ama sınırlı

**Karar:** Pas puan götürmez. Varsayılan pas hakkı tur başına 3'tür, 0 ile sınırsız arasında ayarlanabilir.

**Neden:** Pasın puan götürmesi yeni oyuncuyu cezalandırır. Tamamen serbest olması ise zor kartların hep atlanmasına yol açar. Sınır, ikisinin ortası.

**Bedeli:** Bir ayar daha. Kurulum ekranındaki her ek seçenek ilk karta giden süreyi uzatır.

## 6. Hedefe ulaşılan an oyun biter

**Karar:** Bir takım tur içinde hedef skora ulaştığı anda oyun sona erer, turun bitmesi beklenmez.

**Neden:** Kazanma anı net ve heyecanlı oluyor. Sonucu belli olmuş bir turu sonuna kadar oynatmak anlamsız.

**Bedeli:** Takımlar eşit sayıda tur oynamamış olabilir, ilk başlayan takım avantajlıdır. "Eşit tur" seçeneği yol haritasında aday.

## 7. Kaydırma ve düğme birlikte

**Karar:** Doğru, pas ve tabu hem kartı kaydırarak hem ekranın altındaki düğmelerle yapılabilir. Kaydırmada karar, kartın bırakıldığı yere göre değil hızına göre varacağı yere göre verilir.

**Neden:** Kaydırma hızlı ama keşfedilmesi zor. Telefonu ilk kez eline alan oyuncu düğmeyi görür, alışan oyuncu kaydırır. Düğmeler VoiceOver kullanan oyuncular için de gerekli.

**Bedeli:** Düğmeler ekranda yer kaplıyor, kart daha küçük kalıyor.

## 8. Molada kart gizlenir

**Karar:** Oyun duraklatıldığında kart ekrandan kalkar. Uygulama arka plana geçtiğinde oyun kendiliğinden duraklar.

**Neden:** Süre dururken kartın görünmesi, anlatıcıya düşünmek için bedava zaman verir. Arka plana geçince duraklatma ise gelen bir aramanın turu yakmasını önler.

**Bedeli:** Yok denecek kadar az.

## 9. Kurallar yalnızca ilk oyunda kendiliğinden açılır

**Karar:** Kurallar kartı uygulamanın ilk oyununda kendiliğinden çıkar. Sonraki oyunlarda yalnızca sıra ekranındaki soru işareti düğmesiyle açılır.

**Neden:** Her oyunda çıkan bir kural ekranı düzenli oynayanları yavaşlatır.

**Bedeli:** Telefon sahibi kuralları bir kez görmüş olur. Gruptaki diğer oyuncular ise ancak biri soru işaretine dokunursa görür. Asıl kullanıcı tanımıyla çelişebilecek bir nokta. Gözlemli testte özellikle bakılacak.

## 10. Maskot kodla çizilir

**Karar:** Panda hazır bir görsel değil, `Canvas` ile çizilir.

**Neden:** Yüz ifadesi oyun durumuna göre değişebiliyor: doğruda sevinir, tabuda şaşırır, molada uyur, kazanana taç takar. Her boyutta net kalır.

**Bedeli:** Her yeni ifade tasarım değil kod işi. Bir tasarımcının katkı vermesi zorlaşır.

## 11. En düşük sürüm iOS 26.2'den iOS 17'ye indirildi

**Karar:** 17 Kasım 2026'da en düşük desteklenen sürüm iOS 17.0 yapıldı.

**Neden:** Parti oyununda uygulamanın kimin telefonunda açılacağı belli değil. Gruptan tek bir kişinin telefonunda çalışması yeterli, bu yüzden desteklenen cihaz sayısı yeni API'lerden daha değerli.

**Bedeli:** Yalnızca yeni sürümlerde olan API'ler kullanılamıyor.

## 12. Gelecek paketler uygulamada "Yakında" olarak görünür

**Karar:** Bilim Kurgu, Spor ve Müzik paketleri hazır olmadıkları hâlde seçim ekranında listelenir.

**Neden:** Oyuncuya ürünün büyüdüğünü gösterir.

**Bedeli:** Verilmiş bir söz. Paketler uzun süre gelmezse "Yakında" etiketi güveni azaltır.
