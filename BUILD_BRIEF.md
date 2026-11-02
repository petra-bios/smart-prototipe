# TAHAP 1 — SMART Prototipe: scaffold Flutter + 7 layar + data dummy + navigasi

Kamu bekerja di `/Users/mozespetrabios/Documents/hermes-proj/smart-prototipe/` (pakai path
absolut). **JANGAN mencari di direktori home** — semua yang kamu butuh ada di folder proyek ini.
**FORBIDDEN: pekerjaan background** (jangan jalankan proses latar; kerja berurutan; selesaikan
semuanya di sesi ini).

## Sumber
Baca `docs/prd_smart_prototipe.md` di folder ini — spesifikasi lengkap layar, urutan, teks
persis, warna, dan perilaku. **Ikuti teks persisnya** (judul, tombol, label) dari PRD;
jangan mengarang label lain.

## Tugas tahap ini
1. Scaffold Flutter baru **di folder ini** (yang sudah ada `.git` dan `docs/`). Jangan buat
   folder lain. Nama paket: `smart_prototipe`. Bahasa `lib/` **tidak** perlu dipisah —
   struktur:
   ```
   lib/
     main.dart
     app_colors.dart
     data/dummy_data.dart
     services/dummy_push_service.dart    (seam push dummy — lihat bawah)
     services/api_service.dart           (Dio stub — lihat bawah)
     screens/login_screen.dart
     screens/home_screen.dart
     screens/inbox_screen.dart
     screens/product_screen.dart
     screens/profile_screen.dart
     screens/application_screen.dart
     screens/new_application_screen.dart
     widgets/                            (kartu/banner/nav yang dipakai bersama)
   test/
     ... (lihat gate)
   ```
2. 7 layar persis seperti PRD (urutan bab PRD = urutan implementasi):
   login → home → inbox → produk → profil → aplikasi pengajuan → pengajuan baru.
   - **Entry point ke `application_screen.dart` HANYA dari tombol "Buat Kontrak"**
     di Beranda. Jangan taruh jalur lain.
   - Layar Pengajuan Baru di-entry dari **"Buat Aplikasi Pengajuan Baru"** (tombol bawah)
     yang memunculkan bottom sheet "Buat Pengajuan Kontrak" terlebih dahulu (2 opsi:
     Scan Kode QR → tampilkan SnackBar "Scanner dummy"; Simulasi Cicilan → layar Pengajuan Baru).
   - Bottom nav: Beranda/Inbox/Produk/Profil (IndexedStack atau Navigator biasa).
   - **Teks & warna ikuti PRD persis.** Merah utama #E32127, gradient merah→oranye di
     header Pengajuan Baru, banner survey biru muda.
3. **Push notif**: `dummy_push_service.dart` = service lokal dummy — pakai
   `flutter_local_notifications` kalau dependencies bisa ditambah; kalau tidak bisa,
   cukup stub yang mencatat ke console + overlay SnackBar. **Tidak** pakai Firebase,
   **tidak** ada `google-services.json`.
4. **Dio**: `api_service.dart` pakai `dio` tapi endpoint-nya dummy — hanya `Future.delayed`
   ~500 ms dan kembalikan data dummy dari `dummy_data.dart`. Tidak ada alamat nyata di kode.
5. **WebView**: di Profil ada item "Buka Google" → `webview_flutter` menampilkan
   `https://www.google.com` in-app. Jangan pakai `url_launcher`.
6. **Data dummy** semua di `dummy_data.dart` (username "becky", 7 item inbox, nama POS,
   kategori barang, dsb).

## Gate verifikasi (wajib dijalankan, keluaran ditulis di build.log)
- `flutter analyze` → wajib "No issues found"
- `flutter test` → minimal 10 test lulus; wajib "All tests passed". Cakupan minimal:
  (a) navigasi Masuk → Beranda, (b) tombol "Buat Kontrak" membuka screen Aplikasi Pengajuan
  (bukan screen lain), (c) tombol "Buat Aplikasi Pengajuan Baru" memunculkan bottom sheet
  dengan teks "Buat Pengajuan Kontrak", (d) teks "Pencapaianmu Bulan Ini" dan
  "Kamu bisa clock-in sejauh 150 m dari POSmu" ada di Beranda, (e) bottom nav 4 label ada.
- `flutter build apk --release` → wajib sukses; tulis ukuran APK di build.log.
- JANGAN menjalankan apa pun di background.

## Jangan
- Jangan buat `integration_test/`.
- Jangan pakai Firebase / google-services.
- Jangan ganti mana pun di luar folder proyek.
