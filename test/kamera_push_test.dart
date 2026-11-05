import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_prototipe/screens/home_screen.dart';
import 'package:smart_prototipe/screens/push_status_screen.dart';
import 'package:smart_prototipe/services/push_service.dart';

void main() {
  group('Menu kamera & notifikasi', () {
    testWidgets('Beranda punya tile Kamera dan Notifikasi', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Kamera'), findsOneWidget);
      expect(find.text('Notifikasi'), findsOneWidget);
    });

    testWidgets('Tile Notifikasi membuka layar status push', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Notifikasi'),
        find.byType(SingleChildScrollView).first,
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.ancestor(
          of: find.text('Notifikasi'),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PushStatusScreen), findsOneWidget);
    });
  });

  group('Konfigurasi push', () {
    test('tanpa dart-define, konfigurasi dianggap belum lengkap', () {
      expect(KonfigurasiPush.lengkap, isFalse);
      expect(KonfigurasiPush.hilang, isNotEmpty);
    });

    test('status awal service adalah belum dikonfigurasi', () {
      expect(PushService.instance.status.value, StatusPush.belumDikonfigurasi);
      expect(PushService.instance.token, isNull);
    });

    testWidgets('layar status menjelaskan push belum aktif', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PushStatusScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Belum dikonfigurasi'), findsOneWidget);
      expect(find.text('Nilai yang belum diisi'), findsOneWidget);
      expect(
        find.textContaining('FCM_PROJECT_ID'),
        findsWidgets,
        reason: 'harus menyebut nilai build-flag yang kurang',
      );
    });
  });
}
