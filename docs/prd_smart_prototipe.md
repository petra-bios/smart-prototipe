# PRD Prototipe — SMART (clone prototyping)

Sumber: screenshot aplikasi SMART.DEV v5.7.0 (aplikasi mitra pembiayaan).
Ini **prototipe**: semua data dummy, tidak ada panggilan API nyata.

## Stack yang diminta Mo
- Flutter
- Push notification (fcute path: pakai `firebase_messaging`/seam lokal dummy — tidak perlu
  server; cukup notifikasi lokal sebagai simulasi)
- Dio (untuk kebutuhan prototipe: layer api_service dibungkus dummy — TIDAK memanggil
  endpoint nyata, response-nya statis dummy)
- In-app WebView membuka Google page (tidak boleh keluar app)

## Urutan layar (sesuai urutan nama file screenshot yang Mo kirim)
1. **Login** (`login_screen.dart`) — ala SMART:
   - Logo teks merah "SMART" di kiri atas
   - Field **Username** (isi dummy `becky`), **Password** (disembunyikan, toggle ikon mata)
   - Tautan merah **"Lupa Password?"** di tengah
   - Teks abu-abu kecil **"Versi 5.7.0 prototipe"** di tengah
   - Dekorasi: lingkaran/arc abu-abu besar terpotong di kiri bawah
   - Tombol merah **"Masuk"** — ketuk → langsung pindah ke Beranda (dummy, tak ada auth)
2. **Beranda** (`home_screen.dart`) — ala SMART.DEV:
   - Header putih: logo **SMART.DEV** merah; pill abu-abu gelap kanan
     **Clock-In 11:00 | Clock-Out 20:00** (dipisah garis tipis)
   - Sapaan **"Hi, Becky"**
   - Banner biru muda: **"Yuk isi Survey!"** + deskripsi persisnya dari PRD
   - Kartu putih **"Pencapaianmu Bulan Ini"**: subteks "Volume Rp0 / Rp100.000.000 untuk Naik Level",
     progress bar 0%, kalimat bonus, link biru **"Lihat Hadiah"**
   - Section **"Clock-In"**: kartu "Kamu bisa clock-in sejauh **150 m** dari POSmu" + tombol
     merah "Clock-In" + ilustrasi sederhana (boleh icon composite, tak perlu asset gambar)
   - Dua kartu promosi merah bersebelahan:
     kiri "Ayo, ajak calon pelanggan cek limit pembiayaan mereka!" tombol putih **"Cek Limit"**;
     kanan "Ada calon pelanggan yang tertarik? Yuk, bantu ajukan pembiayaan!" tombol putih
     **"Buat Kontrak"**
   - Bottom nav 4 item: **Beranda** (aktif), **Inbox**, **Produk**, **Profil**
3. **Inbox** (`inbox_screen.dart`):
   - Search bar "Cari"; dropdown "Pilih kategori" + tombol "RESET"
   - List item dummy 7 entri (judul/subjudul/tag/tanggal persis seperti screenshot: dengan
     contoh `Test Reactivation` (SUSPEND, 07 Oct), `ewfewgreghtrj`, `koknklnbj`, dll. —
     jadikan data dummy, tidak masalah kata acak), avatar & chip kategori
     (ilustrasi bisa pakai ikon generik; tidak perlu asset gambar)
   - Chip tag: `SUSPEND`, `BUSINESS PERFORMANCE`, `Sistem SMART`
4. **Produk** (`product_screen.dart`) — placeholder sederhana dummy (daftar/tile statis).
5. **Profil** (`profile_screen.dart`) — placeholder sederhana dummy.
6. **Aplikasi Pengajuan** (`application_screen.dart`) — **ENTRYPOINT: dari tombol
   "Buat Kontrak" di Beranda.**
   - Header: tombol back merah + search bar "Cari No. Aplikasi atau Kontr..."
   - Dua tab: **"Aplikasi Pengajuan"** (aktif, merah) / **"Instruksi Penyerahan"**
   - Empty-state: ilustrasi (ikon generik oke) + "Tidak ada aplikasi yang tersedia"
   - Tombol merah memanjang bawah **"Buat Aplikasi Pengajuan Baru"**
   - **Ketuk tombol itu** → memunculkan **bottom sheet "Buat Pengajuan Kontrak"**
     deskripsi "Pilih metode yang diinginkan pelanggan untuk lanjutkan proses pengajuan."
     dua opsi: **Scan Kode QR** (ikon QR/scan) dan **Simulasi Cicilan** (ikon kalkulator)
   - Tab "Instruksi Penyerahan" juga dummy (empty state sendiri)
7. **Pengajuan Baru - Simulasi** (`new_application_screen.dart`):
   - App bar merah gradient (merah→oranye) + judul putih **"Pengajuan Baru - Simulasi"**
   - Status bar merah (menyatu header)
   - Section **"Informasi pengajuan"**
   - Dropdown **"Nama POS"** dan **"Kategori Barang"** (opsi dummy biasa, cukup 3–5)
   - Tombol pill merah **"Lanjut"** di bawah
   - *"Simulasi Cicilan" dari bottom sheet juga menuju layar ini*

## Warna
- Primer merah ~#E32127 (tombol, tab aktif, logo, indikator)
- Gradasi header pengajuan: merah → oranye/salmon
- Netral: putih, abu muda border/placeholder, abu gelap teks
- Banner survey biru muda

## Perilaku
- Semua klik = aksi dummy (SnackBar/dialog) kecuali alur yang disebut di atas.
- Push notif: saat masuk Beranda, tampilkan 1 notifikasi lokal dummy "Survey menunggu
  kamu" (sebagai demonstrasi). Implementase pakai plugin flutter_local_notifications
  ATAU seam dummy tergantung kemampuan environment build — tampilkan saja di console +
  notifikasi lokal.
- Dio: stub `api_service.dart` — endpoint dummy, delay 500 ms, respons statis, tidak
  ada alamat nyata.
- WebView: di Profil ada item menu "Buka Google" → tampilkan webview in-app google.com.
- Data dummy hard-coded di file separuh: `lib/data/dummy_data.dart`.

## Non-goals
- Tidak ada keamanan/auth nyata.
- Tidak ada database, tidak ada backend, tidak ada permintaan jaringan nyata.
- Tidak perlu asset gambar — pakai ikon + shape + warna.

## Batasan build (untuk coder)
- Gate verifikasi: `flutter analyze` bersih + `flutter test` lulus + `flutter build apk --release`
  + split-per-abi.
- Tidak pakai `integration_test/`.
- Jangan pakai layanan Firebase bawaan (push notif pakai flutter_local_notifications);
  tidak menambah `google-services.json`.
