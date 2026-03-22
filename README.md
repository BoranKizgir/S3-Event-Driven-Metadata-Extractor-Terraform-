# S3-Event-Driven-Metadata-Extractor-Terraform-
Mimari Özellikler
Infrastructure as Code: Tüm altyapı Terraform (v1.0+) kullanılarak modüler ve yönetilebilir şekilde kurgulandı.

Event-Driven: S3 Bucket Notification aracılığıyla Lambda tetiklenmesi sağlandı.

Security (IAM): "Least Privilege" (En az ayrıcalık) prensibiyle, Lambda'nın sadece ilgili S3 ve DynamoDB kaynaklarına erişimi kısıtlandı.

Automation: Python tabanlı Lambda fonksiyonu, yüklenen objelerin boyut, isim ve zaman bilgilerini anlık olarak işler.

 Öğrenme Süreci ve İş Birliği
Bu proje, Terraform Associate sertifikasyon hazırlık sürecimde bir uygulama çalışması olarak geliştirilmiştir. Projenin mimari tasarımı ve Terraform konfigürasyon detaylarında (özellikle IAM politikaları ve tetikleyici mekanizmaları gibi kompleks kısımlarda) yapay zeka (AI) asistanlığından faydalanılmıştır.

# Neden AI Kullandım?

Terraform'un depends_on mantığını ve S3-Lambda arasındaki örtülü/açık bağımlılıkları daha derinlemesine anlamak.

Best-practice'lere uygun (best-practice naming conventions, variables.tf kullanımı) bir yapı kurmak.

Hata ayıklama (debugging) süreçlerini hızlandırarak öğrenme eğrisini pekiştirmek.
