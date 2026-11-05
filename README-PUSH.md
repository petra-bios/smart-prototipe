# Push notifikasi (FCM) — Android + Web

Aplikasi ini sudah punya **kerangka FCM yang jalan** di Android dan web.
Yang belum ada hanya nilainya (milik project Firebase kamu). Tanpa nilai itu,
menu **Notifikasi** menampilkan "Belum dikonfigurasi" dan aplikasi tetap
berjalan normal — tidak crash, tidak ada klaim palsu bahwa push aktif.

## Jalur paling praktis: `google-services.json`

Kalau kamu tidak mau mengetik nilai satu per satu:

1. Firebase Console → Project settings → **Your apps → Android** →
   **Download google-services.json**
2. Taruh di `android/app/google-services.json` (sudah masuk `.gitignore`)

Itu **cukup untuk Android** — plugin Gradle `com.google.gms.google-services`
dipasang otomatis saat build kalau berkasnya ada, dan aplikasi memakai opsinya
langsung. Android push siap tanpa `--dart-define` apa pun.

**Web tetap butuh dua nilai tambahan**, karena keduanya tidak ada di
`google-services.json`:

- `FCM_WEB_APP_ID` — dari app **Web** di project yang sama (Project settings →
  Your apps → Web app → `appId`)
- `FCM_VAPID_KEY` — Project settings → Cloud Messaging → Web Push certificates

Taruh dua nilai itu di `.fcm.env`, lalu:

```bash
python3 tool/siapkan_web_push.py --flags
```

Script membaca `google-services.json` dulu, jadi yang perlu kamu isi hanya dua
nilai web itu.

## Kalau mau tanpa berkas sama sekali (dart-define)

## Yang perlu kamu siapkan (sekali saja)

Semua diambil dari [Firebase Console](https://console.firebase.google.com):

1. **Project Firebase** — boleh project baru (gratis) atau yang sudah ada.
2. **Aplikasi Android** di project itu:
   - Package name: `com.example.smart_prototipe`
   - Setelah dibuat: ⚙ Project settings → General → Your apps → **Android app**
     → salin `mobilesdk_app_id` (bentuknya `1:123456789:android:abc...`)
3. **Aplikasi Web** di project yang sama:
   - Add app → Web → beri nama bebas
   - Salin `appId` web (`1:123456789:web:def...`), `apiKey`, `messagingSenderId`,
     `projectId`
4. **Web Push certificate (VAPID)**:
   - ⚙ Project settings → **Cloud Messaging** → Web Push certificates
   - Klik **Generate key pair** → salin public key (panjang, mulai `B...`)
5. **Kanal pengiriman uji** (pilih salah satu):
   - Paling cepat: Cloud Messaging → **Send test message** → tempel token
     perangkat (token muncul di menu Notifikasi aplikasi)
   - Atau kirim ke **topik `semua`** (aplikasi otomatis berlangganan topik ini),
     lewat Console atau FCM HTTP v1 API
   - Atau aku siapkan script pengirim di mesin ini kalau kamu memberi
     **service account** Firebase (Project settings → Service accounts →
     Generate new private key), taruh di `~/.petrabios-keys/firebase-smart.json`

> Catatan: `google-services.json` **tidak diperlukan** di proyek ini karena
> aplikasi menginisialisasi Firebase dengan opsi eksplisit dari `--dart-define`.
> Artinya kamu cukup mengirim nilai-nilai di atas, bukan berkas.

## Cara memasang nilainya

Buat berkas `.fcm.env` di akar proyek (sudah masuk `.gitignore`):

```env
FCM_API_KEY=AIza...
FCM_PROJECT_ID=nama-project
FCM_SENDER_ID=123456789
FCM_ANDROID_APP_ID=1:123456789:android:abc...
FCM_WEB_APP_ID=1:123456789:web:def...
FCM_VAPID_KEY=BD...
```

Lalu:

```bash
python3 tool/siapkan_web_push.py --flags   # tulis service worker + cetak flag build
flutter build apk --release --target-platform android-arm64 <flag...>
flutter build web --release <flag...>
```

## Batasan yang perlu kamu tahu

- **Web** hanya bisa menerima push pada `https://` atau `http://localhost`.
  Membuka `index.html` langsung dari `file://` tidak akan mendaftarkan service
  worker, jadi push tidak aktif (tombol status akan bilang belum siap).
- **Android** minta izin notifikasi (Android 13+) saat aplikasi dibuka.
- Notifikasi latar (app ditutup) di web ditangani `web/firebase-messaging-sw.js`
  yang digenerasi script di atas.
