import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_prototipe/main.dart';
import 'package:smart_prototipe/screens/application_screen.dart';
import 'package:smart_prototipe/screens/home_screen.dart';
import 'package:smart_prototipe/screens/new_application_screen.dart';
import 'package:smart_prototipe/screens/profile_screen.dart';
import 'package:smart_prototipe/services/api_service.dart';
import 'package:smart_prototipe/services/dummy_push_service.dart';

void main() {
  group('SMART Prototipe Tests', () {
    // Test 1: Login Screen initial rendering
    testWidgets('1. Login screen renders logo, inputs, and version', (tester) async {
      await tester.pumpWidget(const SmartPrototipeApp());
      await tester.pumpAndSettle();

      expect(find.text('SMART'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('becky'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Lupa Password?'), findsOneWidget);
      expect(find.text('Versi 5.7.0 prototipe'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
    });

    // Test 2: (a) Navigasi Masuk -> Beranda
    testWidgets('2. (a) Navigasi Masuk -> Beranda opens HomeScreen', (tester) async {
      await tester.pumpWidget(const SmartPrototipeApp());
      await tester.pumpAndSettle();

      final masukButton = find.widgetWithText(ElevatedButton, 'Masuk');
      expect(masukButton, findsOneWidget);
      await tester.tap(masukButton);
      await tester.pumpAndSettle();

      expect(find.text('Hi, Becky'), findsOneWidget);
      expect(find.text('SMART'), findsOneWidget);
      expect(find.text('.DEV'), findsOneWidget);
      expect(find.text('Clock-In 11:00'), findsOneWidget);
      expect(find.text('Clock-Out 20:00'), findsOneWidget);
    });

    // Test 3: (d) Teks Pencapaianmu Bulan Ini dan Kamu bisa clock-in sejauh 150 m dari POSmu ada di Beranda
    testWidgets('3. (d) Teks Pencapaianmu Bulan Ini & clock-in 150 m ada di Beranda', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pencapaianmu Bulan Ini'), findsOneWidget);
      expect(
        find.text('Volume Rp0 / Rp100.000.000 untuk Naik Level'),
        findsOneWidget,
      );
      expect(find.text('Lihat Hadiah'), findsOneWidget);
      expect(find.text('Yuk isi Survey!'), findsOneWidget);
      expect(find.text('Clock-In'), findsWidgets);
      expect(
        find.text('Kamu bisa clock-in sejauh 150 m dari POSmu'),
        findsOneWidget,
      );
    });

    // Test 4: (e) Bottom nav 4 label ada
    testWidgets('4. (e) Bottom nav 4 label ada (Beranda, Inbox, Produk, Profil)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
      expect(find.text('Produk'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    // Test 5: (b) Tombol "Buat Kontrak" membuka screen Aplikasi Pengajuan (bukan screen lain)
    testWidgets('5. (b) Tombol "Buat Kontrak" membuka screen Aplikasi Pengajuan', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );
      await tester.pumpAndSettle();

      // Dismiss any active notification snackbar
      ScaffoldMessenger.of(tester.element(find.byType(HomeScreen))).clearSnackBars();
      await tester.pumpAndSettle();

      // Scroll content up so promo cards are completely in view above bottom nav
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await tester.pumpAndSettle();

      final buatKontrakBtn = find.widgetWithText(ElevatedButton, 'Buat Kontrak');
      expect(buatKontrakBtn, findsOneWidget);

      await tester.tap(buatKontrakBtn);
      await tester.pumpAndSettle();

      // Verify ApplicationScreen is opened
      expect(find.byType(ApplicationScreen), findsOneWidget);
      expect(find.text('Aplikasi Pengajuan'), findsOneWidget);
      expect(find.text('Instruksi Penyerahan'), findsOneWidget);
      expect(find.text('Tidak ada aplikasi yang tersedia'), findsOneWidget);
      expect(find.text('Buat Aplikasi Pengajuan Baru'), findsOneWidget);
    });

    // Test 6: (c) Tombol "Buat Aplikasi Pengajuan Baru" memunculkan bottom sheet dengan teks "Buat Pengajuan Kontrak"
    testWidgets('6. (c) Tombol "Buat Aplikasi Pengajuan Baru" memunculkan bottom sheet "Buat Pengajuan Kontrak"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ApplicationScreen()),
      );
      await tester.pumpAndSettle();

      final newAppBtn = find.widgetWithText(ElevatedButton, 'Buat Aplikasi Pengajuan Baru');
      expect(newAppBtn, findsOneWidget);
      await tester.tap(newAppBtn);
      await tester.pumpAndSettle();

      expect(find.text('Buat Pengajuan Kontrak'), findsOneWidget);
      expect(
        find.text('Pilih metode yang diinginkan pelanggan untuk lanjutkan proses pengajuan.'),
        findsOneWidget,
      );
      expect(find.text('Scan Kode QR'), findsOneWidget);
      expect(find.text('Simulasi Cicilan'), findsOneWidget);
    });

    // Test 7: Bottom sheet option "Scan Kode QR" triggers SnackBar "Scanner dummy"
    testWidgets('7. Bottom sheet "Scan Kode QR" shows SnackBar "Scanner dummy"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ApplicationScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Buat Aplikasi Pengajuan Baru'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scan Kode QR'));
      await tester.pumpAndSettle();

      expect(find.text('Scanner dummy'), findsOneWidget);
    });

    // Test 8: Bottom sheet option "Simulasi Cicilan" navigates to NewApplicationScreen
    testWidgets('8. Bottom sheet "Simulasi Cicilan" navigates to NewApplicationScreen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ApplicationScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Buat Aplikasi Pengajuan Baru'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simulasi Cicilan'));
      await tester.pumpAndSettle();

      expect(find.byType(NewApplicationScreen), findsOneWidget);
      expect(find.text('Pengajuan Baru - Simulasi'), findsOneWidget);
      expect(find.text('Informasi pengajuan'), findsOneWidget);
      expect(find.text('Nama POS'), findsOneWidget);
      expect(find.text('Kategori Barang'), findsOneWidget);
      expect(find.text('Lanjut'), findsOneWidget);
    });

    // Test 9: Inbox tab switching and items list
    testWidgets('9. Inbox tab displays 7 dummy items and filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialIndex: 1)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cari'), findsOneWidget);
      expect(find.text('RESET'), findsOneWidget);
      expect(find.text('Test Reactivation'), findsOneWidget);
      expect(find.text('ewfewgreghtrj'), findsOneWidget);
      expect(find.text('koknklnbj'), findsOneWidget);
      expect(find.text('SUSPEND'), findsWidgets);
      expect(find.text('BUSINESS PERFORMANCE'), findsWidgets);
      expect(find.text('Sistem SMART'), findsWidgets);
    });

    // Test 10: Profil tab displays profile and "Buka Google" item
    testWidgets('10. Profil tab displays profile and "Buka Google" item', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialIndex: 3)),
      );
      await tester.pumpAndSettle();

      expect(find.text('becky'), findsOneWidget);
      expect(find.text('Buka Google'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);
    });

    // Test 11: Produk tab displays catalog and financing products
    testWidgets('11. Produk tab displays catalog and products', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialIndex: 2)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Produk'), findsWidgets);
      expect(find.text('Katalog Skema Pembiayaan'), findsOneWidget);
      expect(find.text('Daftar Produk Unggulan'), findsOneWidget);
      expect(find.text('Pembiayaan Smartphone & Gadget'), findsOneWidget);
      expect(find.text('Pembiayaan Elektronik Rumah'), findsOneWidget);
    });

    // Test 12: ProfileScreen "Buka Google" opens GoogleWebViewScreen
    testWidgets('12. ProfileScreen "Buka Google" opens GoogleWebViewScreen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialIndex: 3)),
      );
      await tester.pumpAndSettle();

      final bukaGoogle = find.text('Buka Google');
      expect(bukaGoogle, findsOneWidget);
      await tester.tap(bukaGoogle);
      await tester.pumpAndSettle();

      expect(find.byType(GoogleWebViewScreen), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    });

    // Test 13: NewApplicationScreen submit form with "Lanjut"
    testWidgets('13. NewApplicationScreen form submission with "Lanjut"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(builder: (_) => const NewApplicationScreen()),
                ),
                child: const Text('Open Simulation'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Simulation'));
      await tester.pumpAndSettle();

      expect(find.text('Pengajuan Baru - Simulasi'), findsOneWidget);
      expect(find.text('Informasi pengajuan'), findsOneWidget);
      expect(find.text('Nama POS'), findsOneWidget);
      expect(find.text('Kategori Barang'), findsOneWidget);

      final lanjutBtn = find.widgetWithText(ElevatedButton, 'Lanjut');
      expect(lanjutBtn, findsOneWidget);
      await tester.tap(lanjutBtn);
      // Advance by 600ms to allow ApiService delay to complete
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Simulasi pengajuan berhasil dibuat (dummy)'), findsOneWidget);
    });

    // Test 14: ApiService unit test with dummy delay
    test('14. ApiService returns dummy data properly', () async {
      final apiService = ApiService();

      final loginRes = await apiService.login(username: 'becky', password: '123');
      expect(loginRes['success'], isTrue);
      expect(loginRes['username'], equals('becky'));

      final items = await apiService.getInboxItems();
      expect(items.length, equals(7));

      final pos = await apiService.getPosList();
      expect(pos.isNotEmpty, isTrue);

      final submitRes = await apiService.submitApplication(
        posName: pos.first,
        category: 'Smartphone',
      );
      expect(submitRes['success'], isTrue);
      expect(submitRes['status'], equals('SUBMITTED'));
    });

    // Test 15: DummyPushService test
    test('15. DummyPushService initializes and handles notification', () async {
      final pushService = DummyPushService();
      await pushService.init();
      expect(pushService.isInitialized, isTrue);

      await pushService.showNotification(
        title: 'Survey menunggu kamu',
        body: 'Yuk isi Survey!',
      );
    });
  });
}
